extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir= Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
func _process(delta):
		if current_state == 0 or current_state == 1:
			$AnimatedSprite2D.play("idle")
		elif current_state == 2 and !is_chatting:
			if dir.x == -1:
				$AnimatedSprite2D.play("walk_west")
			if dir.x == 1:
				$AnimatedSprite2D.play("walk_east")
			if dir.y == -1:
				$AnimatedSprite2D.play("walk_north")
			if dir.y == 1:
				$AnimatedSprite2D.play("walk_south")
			
		if is_roaming:
			match current_state:
				IDLE:
					pass
				NEW_DIR:
					dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
				MOVE:
					move(delta)
		if Input.is_action_just_pressed("chat") and player_in_chat_zone and !is_chatting:
			print("chatting with npc")
			var dialogue_node = get_tree().root.get_node("world/UI/Dialogue")
			if dialogue_node:
				dialogue_node.start()
				is_roaming = false
				is_chatting = true
				$AnimatedSprite2D.play("idle")
			else:
				push_error("Dialogue node not found at world/UI/Dialogue")
				
func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if !is_chatting:
		position += dir * speed * delta
		

			

	
func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose ([IDLE, NEW_DIR, MOVE])


func _on_dialogue_dialogue_finished() -> void:
	is_chatting = false
	is_roaming = true


func _on_chat_detection_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		player_in_chat_zone = false
		print("Player exited chat zone") 


func _on_chat_detection_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		player = body
		player_in_chat_zone = true
		print("Player entered chat zone")
