extends Node

## Global audio manager. Handles concurrent audio and playback requests.
## Refers to GlobalManager for volume level data.

## Every unique audio file is listed here.
enum AudioEntry {
	TEST_THEME,
	_AUDIO_ENTRY_COUNT,
}

## Audio entry type. Used to apply volume settings correctly.
enum AudioEntryType {
	MUSIC,
	SFX
}

## Playback type. Whether it is looping, and fade type.
enum AudioPlaybackType {
	DEFAULT,
	FADE_IN,
	FADE_OUT,
	FADE_IN_OUT,
	LOOP,
	FADE_IN_LOOP,
	FADE_OUT_LOOP,
	FADE_IN_OUT_LOOP,
}

## Current fade state. Implementation detail.
enum AudioFadeState {
	NONE,
	FADING_IN,
	FADING_OUT
}

## Entries that do not have a fade state.
const no_fade: Array[AudioPlaybackType] = [
	AudioPlaybackType.DEFAULT, AudioPlaybackType.LOOP
]

## Links enum to file path.
const _audio_file_paths = {
	AudioEntry.TEST_THEME : "res://assets/music/beer_type_minus_dreamy.ogg"
}

## Links enum to entry type.
const _audio_file_type = {
	AudioEntry.TEST_THEME : AudioEntryType.MUSIC
}

# ---------- PRIVATE ------------ #

const CONCURRENT_LIMIT: int = 15
var concurrent: int = 0
var _audio_resources: Array[AudioStreamOggVorbis] = []
var _active_fade_ratios: Array[float] = []
var _active_fade_state: Array[AudioFadeState] = []
var _active_resources_types: Array[AudioPlaybackType] = []
var _active_resources_entries: Array[AudioEntry] = []
var _active_resources: Array[AudioStreamPlayer2D] = []
var _active_resources_entries_types: Array[AudioEntryType] = []
	
func _ready() -> void:
	_audio_resources.resize(AudioEntry._AUDIO_ENTRY_COUNT)
	_active_resources.resize(CONCURRENT_LIMIT)
	_active_resources_types.resize(CONCURRENT_LIMIT)
	_active_resources_entries.resize(CONCURRENT_LIMIT)
	_active_fade_state.resize(CONCURRENT_LIMIT)
	_active_fade_ratios.resize(CONCURRENT_LIMIT)
	_active_resources_entries_types.resize(CONCURRENT_LIMIT)

## Clears the entry at specified index and decrements concurrent counter.
func _clear_entry(index: int) -> void:
	_active_fade_ratios[index] = 0.0
	_active_fade_state[index] = AudioFadeState.NONE
	_active_resources_entries[index] = AudioEntry.TEST_THEME
	_active_resources_types[index] = AudioPlaybackType.DEFAULT
	_active_resources_entries_types[index] = AudioEntryType.MUSIC
	_active_resources[index].queue_free()
	_active_resources[index] = null
	concurrent -= 1

## Decides what to do when stream ends. Looping does not 
## incur another fade effect, this is by design.
func _stream_ended(index: int, loop: bool) -> void:
	if loop:
		_active_resources[index].play()
		return
	_clear_entry(index)
	
func _process(delta: float) -> void:
	for i in range(CONCURRENT_LIMIT):
		if not _active_resources[i]:
			continue
		var set_vol: float =  0.0
		match _active_resources_entries_types[i]:
			AudioEntryType.MUSIC: set_vol = GlobalManager.get_state(
				GlobalManager.StateType.MUSIC_VOLUME
			)
			AudioEntryType.SFX: set_vol = GlobalManager.get_state(
				GlobalManager.StateType.SFX_VOLUME
			)
		set_vol *= GlobalManager.get_state(GlobalManager.StateType.MASTER_VOLUME)
		match _active_fade_state[i]:
			AudioFadeState.FADING_IN: 
				if _active_resources[i].volume_linear >= set_vol:
					_active_resources[i].volume_linear = set_vol
					_active_fade_state[i] = AudioFadeState.NONE
					continue
				_active_resources[i].volume_linear += _active_fade_ratios[i] * delta
			AudioFadeState.FADING_OUT: 
				if _active_resources[i].volume_linear <= 0.0:
					_clear_entry(i)
				_active_resources[i].volume_linear -= _active_fade_ratios[i] * delta
			AudioFadeState.NONE:
				_active_resources[i].volume_linear = set_vol
		if _active_resources_types[i] in no_fade:
			continue
		var stream_length: float =  _active_resources[i].stream.get_length()
		var crnt_time: float = _active_resources[i].get_playback_position()
		var diff: float = stream_length - crnt_time
		var start_fade_out: bool = diff <= 1.0 / _active_fade_ratios[i]
		
		# Only non-looping fade types.
		if start_fade_out and _active_resources_types[i] < AudioPlaybackType.LOOP: 
			_active_fade_state[i] = AudioFadeState.FADING_OUT
		
# ----------- PUBLIC ------------- #

## Plays an instance of the audio `entry` that was specified.
func play(entry: AudioEntry, playback_type = AudioPlaybackType.DEFAULT, fade_duration = 1.0) -> void:
	if concurrent == CONCURRENT_LIMIT:
		return
	if not _audio_resources[entry]:
		_audio_resources[entry] = load(_audio_file_paths[entry])
	var stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	get_tree().root.add_child(stream_player)
	
	var i: int = 0
	for stream in _active_resources:
		if not stream:
			break
		i += 1
	stream_player.stream = _audio_resources[entry]
	print(playback_type >= AudioPlaybackType.LOOP)
	stream_player.finished.connect(_stream_ended.bind(i, playback_type >= AudioPlaybackType.LOOP))
	stream_player.volume_linear = 0.0
	stream_player.play()
	
	_active_resources[i] = stream_player
	_active_resources_entries[i] = entry
	_active_resources_types[i] = playback_type
	_active_resources_entries_types[i] = _audio_file_type[entry]
	
	if playback_type not in no_fade: 
		_active_fade_state[i] = AudioFadeState.FADING_IN
		
		# NOTE: Fade ratio is fixed at start-up. So I took a default with the max
		# of 1.0. This can cause the fade to complete earlier for lower volumes.
		_active_fade_ratios[i] = 1.0 / fade_duration
	else: 
		_active_fade_state[i] = AudioFadeState.NONE
	
	concurrent += 1
	
## Stops one playing instance of audio of type `entry`.
func stop_one(entry: AudioEntry, immediate = false) -> void:
	var i: int = 0
	for res in _active_resources:
		if not res:
			i += 1
			continue
		var stop: bool = immediate or _active_resources_types[i] in no_fade
		var matched: bool = _active_resources_entries[i] == entry
		if matched and stop:
			_clear_entry(i)
			break
		elif matched:
			_active_fade_state[i] = AudioFadeState.FADING_OUT
			break
		i += 1

## Stops all playing audio of type `entry`.
func stop_type(entry: AudioEntry, immediate = false) -> void:
	var i: int = 0
	for res in _active_resources:
		if not res:
			i += 1
			continue
		var stop: bool = immediate or _active_resources_types[i] in no_fade
		var matched: bool = _active_resources_entries[i] == entry
		if matched and stop:
			_clear_entry(i)
		elif matched:
			_active_fade_state[i] = AudioFadeState.FADING_OUT
		i += 1

## Stops all audio.
func stop_all(immediate = false) -> void:
	var i: int = 0
	for res in _active_resources:
		if not res:
			i += 1
			continue
		if immediate or _active_resources_types[i] in no_fade:
			_clear_entry(i)
		else:
			_active_fade_state[i] = AudioFadeState.FADING_OUT
		i += 1
