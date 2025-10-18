extends Node2D


@onready var platform_container = $PlatformContainer


var active_platform = null
var current_letter_index : int = -1


func find_new_active_platform(typed_character : String):
	for platform in platform_container.get_children():
		var prompt = platform.get_prompt()
		var next_character = prompt.substr(0, 1)


		if next_character == typed_character:
			print("Successfully found enemy that starts with %s" % next_character)
			active_platform = platform
			current_letter_index = 1


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()


		if active_platform == null:
			find_new_active_platform(key_typed)
		else:
			var prompt = active_platform.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)

			if key_typed == next_character:
				print("Successfully typed %s" % key_typed)
				current_letter_index += 1

				if current_letter_index == prompt.length():
					print("Done")
					current_letter_index = -1
					$PlatformContainer/Platform/Platform2/CollisionShape2D.disabled = false
					active_platform = null
			else:
				print("Incorrectly typed %s instead of %s" % [key_typed, next_character])
