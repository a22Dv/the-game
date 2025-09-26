extends Node2D

func _on_button_button_down() -> void:
	GlobalManager.pop_scene()

func _ready() -> void:
	AudioManager.play(
		AudioManager.AudioEntry.TEST_THEME, 
		AudioManager.AudioPlaybackType.FADE_IN_OUT_LOOP,
		3.0
	)
