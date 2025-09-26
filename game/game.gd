extends Node2D

func _on_button_button_down() -> void:
	# AudioManager.stop_all()
	GlobalManager.pop_scene()

func _ready() -> void:
	AudioManager.play.call_deferred(
		AudioManager.AudioEntry.MINUS_DREAMY, 
		AudioManager.AudioPlaybackType.FADE_IN_OUT_LOOP,
		3.0
	)
