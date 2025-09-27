extends CharacterBody2D


@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	#input (just used the default arrow keys cause the wasd keys dont wanna cooperate?)
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# normalise prevent diagonal speed boost
	input_vector = input_vector.normalized()

	#movement
	velocity = input_vector * speed
	move_and_slide()
