extends Control

signal dialogue_finished

@export_file("*.json") var d_file

var dialogue = []
var current_dialogue_id = 0
var d_active = false

func _ready():
	$NinePatchRect.visible = false
	
	
func start(dialogue_path: String, npc_name: String):
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
	var file = FileAccess.open("res://dialogue/worket_dialogue_1.json", FileAccess.READ)
	if file:
		var content = JSON.parse_string(file.get_as_text())
		if typeof(content) == TYPE_ARRAY:
			return content
	return []
	
func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("chat"):
		next_script()
	
	
func next_script():
	$NinePatchRect.visible = true
	$NinePatchRect/Name.text = "NPC"
	$NinePatchRect/Text.text = "This is a test dialogue box that should now appear at the bottom of the screen."
	current_dialogue_id += 1
	print("Dialogue step:", current_dialogue_id, "/", len(dialogue))
	if current_dialogue_id >= len(dialogue):
		d_active = false
		$NinePatchRect.visible = false
		emit_signal("dialogue_finished")
		print("Dialogue finished signal emitted!")
		return
		
		
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]['text']
