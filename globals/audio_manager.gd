extends Node

## Global audio manager. Handles concurrent audio and playback requests.
## Refers to GlobalManager for volume level data.

## Audio entry type. Used to apply volume settings correctly.
enum AudioEntryType {
	MUSIC,
	SFX
}
# --------------------------------------- DATA --------------------------------------------------- #
## Every unique audio file is listed here.
enum AudioEntry {
	TEST_THEME,
	_AUDIO_ENTRY_COUNT,
}

## Links enum to file path.
const _audio_file_paths = {
	AudioEntry.TEST_THEME : "res://assets/music/beer_type_minus_dreamy.ogg"
}

## Links enum to entry type.
const _audio_file_type = {
	AudioEntry.TEST_THEME : AudioEntryType.MUSIC
}
# --------------------------------------- IMPL --------------------------------------------------- #

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

# ---------------------------------------- PRIVATE ----------------------------------------------- #

const CONCURRENT_LIMIT: int = 15
var concurrent: int = 0

class ActiveEntry extends RefCounted:
	var fade_ratio: float
	var fade_state: AudioFadeState
	var playback_type: AudioPlaybackType
	var player: AudioStreamPlayer2D
	var entry: AudioEntry
	var entry_type: AudioEntryType

var _active_entries: Array[ActiveEntry] = []
var _audio_resources: Array[AudioStreamOggVorbis] = []
	
func _ready() -> void:
	_audio_resources.resize(AudioEntry._AUDIO_ENTRY_COUNT)
	_active_entries.resize(CONCURRENT_LIMIT)

## Clears the entry at specified index and decrements concurrent counter.
func _clear_entry(index: int) -> void:
	_active_entries[index].player.queue_free()
	_active_entries[index] = null
	concurrent -= 1

## Decides what to do when stream ends. Looping does not 
## incur another fade effect, this is by design.
func _stream_ended(index: int, loop: bool) -> void:
	if loop:
		_active_entries[index].player.play()
		return
	_clear_entry(index)
	
func _process(delta: float) -> void:
	var i: int = -1
	for entry in _active_entries:
		i += 1
		if not entry:
			continue
		var set_vol: float =  0.0
		match entry.entry_type:
			AudioEntryType.MUSIC: set_vol = GlobalManager.get_state(
				GlobalManager.StateType.MUSIC_VOLUME
			)
			AudioEntryType.SFX: set_vol = GlobalManager.get_state(
				GlobalManager.StateType.SFX_VOLUME
			)
		set_vol *= GlobalManager.get_state(GlobalManager.StateType.MASTER_VOLUME)
		match entry.fade_state:
			AudioFadeState.FADING_IN: 
				var nvol: float = entry.player.volume_linear + entry.fade_ratio * delta
				if nvol >= set_vol:
					entry.player.volume_linear = set_vol
					entry.fade_state = AudioFadeState.NONE
					continue
				entry.player.volume_linear = nvol
			AudioFadeState.FADING_OUT: 
				var nvol: float = entry.player.volume_linear - entry.fade_ratio * delta
				if nvol <= 0.0:
					_clear_entry(i)
					continue
				entry.player.volume_linear = nvol
			AudioFadeState.NONE:
				entry.player.volume_linear = set_vol
		if entry.playback_type in no_fade:
			continue
		var stream_length: float = entry.player.stream.get_length()
		var crnt_time: float = entry.player.get_playback_position()
		var diff: float = stream_length - crnt_time
		var start_fade_out: bool = diff <= 1.0 / entry.fade_ratio
		if start_fade_out and entry.playback_type < AudioPlaybackType.LOOP: 
			# Only non-looping fade types.
			entry.fade_state = AudioFadeState.FADING_OUT
		
# ---------------------------------------- PUBLIC ----------------------------------------------- #

## Plays an instance of the audio `entry` that was specified.
func play(entry: AudioEntry, playback_type = AudioPlaybackType.DEFAULT, fade_duration = 1.0) -> void:
	if concurrent == CONCURRENT_LIMIT:
		return
	if not _audio_resources[entry]: _audio_resources[entry] = load(_audio_file_paths[entry])

	var i: int = 0
	for ent in _active_entries:
		if not ent: break
		i += 1
	var active_entry: ActiveEntry = ActiveEntry.new()
	active_entry.player = AudioStreamPlayer2D.new()
	active_entry.player.stream = _audio_resources[entry]
	active_entry.player.finished.connect(
		_stream_ended.bind(i, playback_type >= AudioPlaybackType.LOOP)
	)
	active_entry.player.volume_linear = 0.0
	active_entry.playback_type = playback_type
	active_entry.entry_type = _audio_file_type[entry]
	active_entry.entry = entry
	if playback_type not in no_fade:
		active_entry.fade_state = AudioFadeState.FADING_IN
		active_entry.fade_ratio = 1.0 / fade_duration
	else:
		# NOTE: Fade ratio is fixed at start-up. So I took a default with the max
		# of 1.0. This can cause the fade to complete earlier for lower volumes.
		active_entry.fade_state = AudioFadeState.NONE
		active_entry.fade_ratio = 0.0
	get_tree().root.add_child(active_entry.player)
	active_entry.player.play()
	_active_entries[i] = active_entry
	concurrent += 1
	
## Stops one playing instance of audio of type `entry`.
func stop_one(entry: AudioEntry, immediate = false) -> void:
	var i: int = -1
	for ent in _active_entries:
		i += 1
		if not ent: continue
		var stop: bool = immediate or ent.playback_type in no_fade
		var matched: bool = ent.entry == entry
		if matched and stop:
			_clear_entry(i)
			break
		elif matched:
			ent.fade_state = AudioFadeState.FADING_OUT
			break

## Stops all playing audio of type `entry`.
func stop_type(entry: AudioEntry, immediate = false) -> void:
	var i: int = -1
	for ent in _active_entries:
		i += 1
		if not ent: continue
		var stop: bool = immediate or ent.playback_type in no_fade
		var matched: bool = ent.entry == entry
		if matched and stop: _clear_entry(i)
		elif matched: ent.fade_state = AudioFadeState.FADING_OUT

## Stops all audio.
func stop_all(immediate = false) -> void:
	var i: int = -1
	for ent in _active_entries:
		i += 1
		if not ent: continue
		if immediate or ent.playback_type in no_fade: _clear_entry(i)
		else: ent.fade_state = AudioFadeState.FADING_OUT
