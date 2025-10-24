extends Control

signal dialogue_finished(npc_name)

@export_file("*.json") var d_file

var dialogue = []
var current_dialogue_id = 0
var d_active = false
var current_dialogue_npc = ""

func _ready():
	$NinePatchRect.visible = false
	
	
func start(dialogue_path: String, npc_name: String):
	current_dialogue_npc = npc_name
	$NinePatchRect/Text.text = "WORLD"
	print("yes")
	
	if d_active:
		return
	
	d_active = true
	$NinePatchRect.visible = true
	dialogue = load_dialogue(dialogue_path)
	current_dialogue_id = -1
	next_script()
	
func load_dialogue(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = JSON.parse_string(file.get_as_text())
		if typeof(content) == TYPE_ARRAY:
			return content
		else:
			push_error("Dialogue file not found: " + path)
	return []
	
func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("chat"):
		next_script()
	
	
func next_script():
	$NinePatchRect.visible = true
	
	current_dialogue_id += 1
	print("Dialogue step:", current_dialogue_id, "/", len(dialogue))
	
	if current_dialogue_id >= len(dialogue):
		d_active = false
		$NinePatchRect.visible = false
		emit_signal("dialogue_finished", current_dialogue_npc)
		print("Dialogue finished signal emitted!")
		return
	
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]["name"]
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]["text"]
	
	if dialogue[current_dialogue_id].has("portrait"):
		var portrait_path = dialogue[current_dialogue_id]["portrait"]
		if FileAccess.file_exists(portrait_path):
			$NinePatchRect/Portrait.texture = load(portrait_path)
			$NinePatchRect/Portrait.visible = true
		else:
			push_error("Portrait not found: " + portrait_path)
			$NinePatchRect/Portrait.visible = false
	else:
		$NinePatchRect/Portrait.visible = false
