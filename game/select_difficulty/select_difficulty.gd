extends Node2D

@onready var back_btn: Button = $Control/Panel/Back
func _ready() -> void:
	AudioManager.play(
		AudioManager.AudioEntry.MINUS_DREAMY,
		AudioManager.AudioPlaybackType.FADE_IN_OUT_LOOP,
		true,
		true,
		2.0
	)
	back_btn.button_down.connect(on_back)
	
func on_back() -> void:
	GlobalManager.pop_scene()
