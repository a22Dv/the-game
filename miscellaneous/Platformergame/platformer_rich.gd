extends Node2D

var active_platform = null
var current_letter_index: int = -1

func find_new_active_platform(typed_character: String ):
	print("new Platform")
	var prompt = $Platform.get_prompt( )
	if prompt.substr(0, 1) == typed_character:
		active_platform == $Platform
		print("new enemy")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		
		if active_platform == null:
			find_new_active_platform(key_typed)
		
	
