extends Node

## Global audio manager. Handles concurrent audio and playback requests.
## Refers to GlobalManager for volume level data.

enum AudioEntry {
	TEST_THEME,
	_AUDIO_ENTRY_COUNT
}

# ---------- PRIVATE ------------ #

var _audio_resources: Array[AudioStreamOggVorbis] = []
var _active_queue: Array[AudioStreamPlayer2D] = []

func _ready() -> void:
	_audio_resources.resize(AudioEntry._AUDIO_ENTRY_COUNT)

# ----------- PUBLIC ------------- #

func play(entry: AudioEntry, fade_in = false, fade_in_time = 1.0, loop = false) -> void:
	pass

func stop_oldest(entry: AudioEntry, fade_out = false, fade_out_time = 1.0) -> void:
	pass

func stop_all(entry: AudioEntry, fade_out = false, fade_out_time = 1.0) -> void:
	pass
