extends Node2D

@onready var vol_sliders: Dictionary = {
	StateType.MASTER_VOLUME : $Control/Panel/HBoxContainer/VBoxContainer/Master,
	StateType.MUSIC_VOLUME : $Control/Panel/HBoxContainer/VBoxContainer/Music,
	StateType.SFX_VOLUME : $Control/Panel/HBoxContainer/VBoxContainer/Sfx
}

const NORM: float = 100.0
var StateType = GlobalManager.StateType

func _ready() -> void:
	for st in vol_sliders.keys():
		var slider: HSlider = vol_sliders[st]
		slider.value = GlobalManager.get_state(st) * NORM
		slider.value_changed.connect(_on_vol_drag_ended.bind(st))
		
func _on_vol_drag_ended(value_changed: float, st: GlobalManager.StateType) -> void:
	if value_changed:
		GlobalManager.set_state(st, value_changed / NORM)

func _on_back_button_down() -> void:
	GlobalManager.pop_scene()
