extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir= Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

@export var npc_name: String = "Jeremih"
@export var dialogue_file: String = "res://dialogues/jeremih_dialogue.json"

var has_talked = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	
	print("Testing QuestManager:", Engine.get_singleton("QuestManager"))
	
	if Engine.has_singleton("QuestManager"):
		QuestManager.register_npc(npc_name)
	else:
		push_error("QuestManager not found!")
		
		var dialogue_node = get_tree().root.get_node("world/UI/Dialogue")
		if dialogue_node:
			dialogue_node.connect("dialogue_finished", Callable(self, "_on_dialogue_dialogue_finished"))
			print("Dialogue signal connected for ", npc_name)
			print("Connected to dialogue node: ", dialogue_node)
		else:
			push_error("Dialogue node not found at world/UI/Dialogue")
	
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
			if has_talked:
				print("%s has already been talked to." % npc_name)
				return
			print("chatting with npc")
			var dialogue_node = get_tree().root.get_node("world/UI/Dialogue")
			if dialogue_node:
				dialogue_node.start("res://dialogue/" + npc_name.to_lower() + "_dialogue_1.json", npc_name)
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
	print("%s received dialogue_finished signal!" % npc_name)
	is_chatting = false
	is_roaming = true
	
	if not has_talked:
		has_talked = true

		if QuestManager:
			print("QuestManager autoload found directly!")
			QuestManager.npc_talked_to(npc_name)
			print("%s talked to!" % npc_name)
			var mission_panel = get_tree().root.get_node("world/UI/MissionPanel")
			if mission_panel:
				mission_panel.mark_npc_as_talked(npc_name)
		else:
			push_error("QuestManager global variable not found!")


func _on_chat_detection_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		player_in_chat_zone = false
		print("Player exited chat zone") 


func _on_chat_detection_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":
		player = body
		player_in_chat_zone = true
		print("Player entered chat zone")
		
func start_dialogue():
	is_chatting = true
	var dialogue_node = get_tree().root.get_node("world/UI/Dialogue")

	if dialogue_node:
		
		dialogue_node.start("res://dialogue/" + npc_name.to_lower() + "_dialogue_1.json", npc_name)
	else:
		push_error("Dialogue node not found at world/UI/Dialogue")
