extends Node2D

@onready var rich_btn: Button = $Control/Panel/Rich
@onready var back_btn: Button = $Control/Panel/Back


func _ready() -> void:
	GlobalManager._register(self)
	
	var callables: Array[Callable] = [on_rich]
	var i: int = 0
	for btn in [rich_btn]:
		btn.button_down.connect(callables[i])
		i += 1
		
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
func on_rich() -> void:
	GlobalManager.push_scene("res://hubs/RichHub.tscn")
