extends Node2D

@onready var rich_hub_btn: Button = $Control/Panel/rich
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

func on_rich_hub() -> void:
	GlobalManager.push_scene("res://hubs/rich_hub.tscn")

func on_back() -> void:
	GlobalManager.pop_scene()
