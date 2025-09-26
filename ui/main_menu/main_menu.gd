extends Node2D

@onready var start_btn: Button = $Placeholder/VBoxContainer/Start
@onready var quit_btn: Button = $Placeholder/VBoxContainer/Quit
@onready var settings_btn: Button = $Placeholder/VBoxContainer/Settings

func _ready() -> void:
	GlobalManager._register(self)

func _on_quit_button_down() -> void:
	GlobalManager.quit()

func _on_start_button_down() -> void:
	GlobalManager.push_scene("res://game/game.tscn")

func _on_settings_button_down() -> void:
	GlobalManager.push_scene("res://ui/settings.tscn")
