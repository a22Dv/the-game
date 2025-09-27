extends Node2D

@onready var newgame_btn: Button = $Control/Panel/HBoxContainer/VBoxContainer/NewGame
@onready var continue_btn: Button = $Control/Panel/HBoxContainer/VBoxContainer/Continue
@onready var settings_btn: Button = $Control/Panel/HBoxContainer/VBoxContainer/Settings
@onready var quit_btn: Button = $Control/Panel/HBoxContainer/VBoxContainer/Quit

func _ready() -> void:
	
	# Registers itself with the global manager.
	# This is a one-time requirement due to the fact that 
	# the main menu is the first scene, which is loaded by Godot and not
	# by the manager.
	GlobalManager._register(self)
	
	var callables: Array[Callable] = [on_newgame, on_continue, on_settings, on_quit]
	var i: int = 0
	for btn in [newgame_btn, continue_btn, settings_btn, quit_btn]:
		btn.button_down.connect(callables[i])
		i += 1
	AudioManager.play(
		AudioManager.AudioEntry.WHOLESOME_FANTASY,
		AudioManager.AudioPlaybackType.FADE_IN_OUT_LOOP,
		true,
		true,
		2.0
	)

# Currently, new game and continue redirects to a new instance.
# saving logic required for on_continue() to be functional.
func on_newgame() -> void:
	GlobalManager.push_scene("res://game/select_difficulty/select_difficulty.tscn")
func on_continue() -> void:
	GlobalManager.push_scene("res://game/game.tscn")
func on_settings() -> void:
	GlobalManager.push_scene("res://ui/settings/settings.tscn")
func on_quit() -> void:
	GlobalManager.quit()
	
