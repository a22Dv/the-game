extends CharacterBody2D


const SPEED = 167.0
const JUMP_VELOCITY = -400.0
const DASH_speed = 67
const DASH_duration = 2

var isDashing: bool = false
var isGrounded: bool =false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#DASH
	#if !isDashing: velocity = SPEED * DASH_speed
	
	
	move_and_slide()
