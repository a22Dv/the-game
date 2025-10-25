extends TextureRect


var talked_to = {
	"Jeremih": false,
	"Princess Salazar": false,
	"Samantha 'sammie' Kho": false,
	"Glenn Carew-Gibbs": false,
	"Magdaleine Nicole Stalley": false,
}

@onready var title_label = $Title
@onready var mission_label = $MissionDescription
@onready var npc_list = $NPCList
@onready var total_label = $TotalLabel
@onready var fade_overlay = $FadeOverlay

func _ready() -> void:
	title_label.text = "MISSION"
	mission_label.text = "TALK TO 6 PEOPLE"
	mission_label.visible = false
	fade_overlay.visible = false
	
	var mission_complete_label = get_node_or_null("MissionCompleteLabel")
	if mission_complete_label:
		mission_complete_label.visible = false
	else:
		push_error("MissionCompleteLabel not found under MissionPanel")
	
	update_ui()


	mission_label.visible = false
	
	if Engine.has_singleton("QuestManager"):
		QuestManager.connect("npc_talked", Callable(self,"_on_npc_talked"))
		QuestManager.connect("mission_completed", Callable(self, "_on_mission_completed"))
	else:
		push_error("QuestManager not found!")

func _on_npc_talked(npc_name: String):
	if npc_name in talked_to:
		talked_to[npc_name] = true
		print("%s marked as talked to in MissionPanel" % npc_name)
		update_ui()
	else:
		print("Warning: '%s' not found in talked_to dictionary" % npc_name)

func update_ui():
	for npc_name in talked_to.keys():
		var npc_entry = npc_list.get_node_or_null(npc_name)
		if npc_entry:
			var label = npc_entry.get_node("NameLabel")
			var check = npc_entry.get_node("Check")
			label.text = npc_name
			check.text = "☑" if talked_to[npc_name] else "☐"
		else:
			print("Warning: Missing UI entry for ", npc_name)

	var total = talked_to.values().count(true)
	total_label.text = "Total NPCs Talked To: %d / %d" % [total, talked_to.size()]

	if total == talked_to.size():
		print("Mission complete!")
		show_mission_complete()


func mark_npc_as_talked(npc_name: String):
	if npc_name in talked_to:
		talked_to[npc_name] = true
		update_ui()
	else:
		print("Warning: NPC '%s' not found in talked_to dictionary" % npc_name)

func show_mission_complete():
	print("Showing Mission Complete UI...")

	for child in get_children():
		child.visible = false

	fade_overlay.visible = true
	$MissionCompleteLabel.visible = true

	$MissionCompleteLabel.text = "MISSION COMPLETE!"
	$MissionCompleteLabel.add_theme_color_override("font_color", Color.WHITE)

	fade_overlay.color.a = 0
	var tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 1.0, 1.5)
	tween.tween_property($MissionCompleteLabel, "modulate:a", 1.0, 1.5).from(0)

func _show_only_text():
	for child in get_children():
		if child != title_label and child != mission_label and child != fade_overlay:
			child.visible = false

	title_label.visible = true
	mission_label.visible = true
	title_label.modulate.a = 0
	mission_label.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(title_label, "modulate:a", 1.0, 1.0)
	tween.tween_property(mission_label, "modulate:a", 1.0, 1.0)

func fade_to_black(node: ColorRect):
	for i in range(21):
		node.color.a = i / 20.0
		await get_tree().create_timer(0.05).timeout
		
