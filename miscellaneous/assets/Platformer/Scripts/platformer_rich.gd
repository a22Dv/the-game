extends Node2D

#initializes variables and prepares platform states
var inactive_platform = null
var current_letter_index: int = -1
var incomplete_platform
var complete_platform

#search for new inactive platforms (platforms who have their colliders turned off)
func find_new_inactive_platform(typed_character: String):
	var prompt = $platform.get_prompt()
	var next_character = prompt.substr(0, 1)
	if next_character == typed_character:
		print("Found new enemey: %s" % next_character)
		inactive_platform == $platform
		current_letter_index = 1

#handles prompts 
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_pressed(): 
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
		
		#finds new platform once process has been finished
		if inactive_platform == null:
			find_new_inactive_platform(key_typed)
		else:
			var prompt = inactive_platform.getprompt()
			var next_character = prompt.subtr(current_letter_index, 1)
			if key_typed == next_character:
			#use this to turn collision off and on
				print("success, typed %s" % key_typed)
				current_letter_index += 1
				if current_letter_index == prompt.length():
					print("done current letter index equals prompt length")
					current_letter_index = -1
					inactive_platform.queue_free()
					inactive_platform = null
				else:
					print("incorrectly typed $s instead of %d" % [key_typed, next_character])
