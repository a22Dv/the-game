extends CharacterBody2D

#copy pasted from the hub
@export var speed: float = 300.0

func _physics_process(_delta: float) -> void:
	var input_vector = Vector2.ZERO

	#input (just used the default arrow keys cause the wasd keys dont wanna cooperate?)
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# normalise prevent diagonal speed boost
	input_vector = input_vector.normalized()

	#movement
	velocity = input_vector * speed
	move_and_slide()
