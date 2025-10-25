extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

@export var npc_name: String = "Jeremih"
@export_file("*.json") var dialogue_file = "res://dialogue/worket_dialogue_1.json"

var has_talked = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func find_node_recursive(root: Node, target_name: String) -> Node:
	if root == null:
		return null
	if root.name == target_name:
		return root
	for child in root.get_children():
		var found := find_node_recursive(child, target_name)
		if found:
			return found
	return null

func _ready():
	randomize()
	start_pos = position

	print("Testing QuestManager:", QuestManager)

	if QuestManager:
		QuestManager.register_npc(npc_name)
		if QuestManager.has_method("connect_dialogue"):
			QuestManager.connect_dialogue(self)
	else:
		push_error("QuestManager autoload not found!")

	var root_node = get_tree().get_root() 
	var dialogue_node = find_node_recursive(root_node, "Dialogue")
	if dialogue_node:
		if not dialogue_node.is_connected("dialogue_finished", Callable(self, "_on_dialogue_dialogue_finished")):
			dialogue_node.connect("dialogue_finished", Callable(self, "_on_dialogue_dialogue_finished"))
		print("Dialogue signal connected for ", npc_name, " -> ", dialogue_node)
	else:
		push_warning("Dialogue node not found in scene tree (searched from root). Make sure a node named 'Dialogue' exists in the current scene.")

func _process(delta):
	if current_state == IDLE or current_state == NEW_DIR:
		$AnimatedSprite2D.play("idle")
	elif current_state == MOVE and !is_chatting:
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

		var root_node = get_tree().get_root()
		var dialogue_node = find_node_recursive(root_node, "Dialogue")
		if dialogue_node and dialogue_node.has_method("start"):
			dialogue_node.start(dialogue_file, npc_name)
			is_roaming = false
			is_chatting = true
			$AnimatedSprite2D.play("idle")
		else:
			push_error("Dialogue node (with method start) not found in scene tree. Searched from root.")

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		position += dir * speed * delta

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])

func _on_dialogue_dialogue_finished(finished_npc: String) -> void:
	if finished_npc != npc_name:
		return

	print("%s received dialogue_finished signal!" % npc_name)
	is_chatting = false
	is_roaming = true

	if not has_talked:
		has_talked = true

		if QuestManager:
			print("QuestManager autoload found directly!")
			QuestManager.npc_talked_to(npc_name)
			print("%s talked to!" % npc_name)

			var root_node = get_tree().get_root()
			var mission_panel_node = find_node_recursive(root_node, "MissionPanel")
			if mission_panel_node and mission_panel_node.has_method("mark_npc_as_talked"):
				mission_panel_node.mark_npc_as_talked(npc_name)
			else:
				var ui_node = find_node_recursive(root_node, "UI")
				if ui_node:
					var panel = ui_node.get_node_or_null("MissionPanel")
					if panel and panel.has_method("mark_npc_as_talked"):
						panel.mark_npc_as_talked(npc_name)
					else:
						push_warning("MissionPanel not found or missing 'mark_npc_as_talked' method.")
				else:
					push_warning("UI node not found in scene; can't update mission panel.")
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
	var root_node = get_tree().get_root()
	var dialogue_node = find_node_recursive(root_node, "Dialogue")
	if dialogue_node and dialogue_node.has_method("start"):
		dialogue_node.start(dialogue_file, npc_name)
	else:
		push_error("Dialogue node not found in scene tree or missing 'start' method.")
