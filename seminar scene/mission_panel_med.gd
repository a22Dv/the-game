extends TextureRect

var talked_to = {
	"Abel Tabar": false,
	"CJ Morales": false,
	"Celeste De la Torre": false,
}

@onready var title_label = $Title
@onready var mission_label = $MissionDescription
@onready var npc_list = $NPCList
@onready var total_label = $TotalLabel
@onready var fade_overlay = $FadeOverlay

func _ready() -> void:
	title_label.text = "MISSION"
	mission_label.text = "TALK TO SPECIFIC PEOPLE"
	title_label.visible = false
	mission_label.visible = false
	fade_overlay.visible = false

	var mission_complete_label = get_node_or_null("MissionCompleteLabel")
	if mission_complete_label:
		mission_complete_label.visible = false
	else:
		push_warning("MissionCompleteLabel not found under MissionPanel (expected node name: 'MissionCompleteLabel')")

	if Engine.has_singleton("QuestManager"):
		QuestManager.set_mode("medium")
		QuestManager.connect("npc_talked", Callable(self, "_on_npc_talked"))
		QuestManager.connect("mission_completed", Callable(self, "_on_mission_completed"))
	else:
		push_error("QuestManager not found!")

	update_ui()


func _on_npc_talked(npc_name: String) -> void:
	if npc_name in talked_to:
		talked_to[npc_name] = true
		print("%s marked as talked to in MissionPanel (medium)" % npc_name)
		update_ui()
	else:
		print("NPC '%s' is not part of the medium mission." % npc_name)


func update_ui() -> void:
	for npc_name in talked_to.keys():
		var npc_entry = npc_list.get_node_or_null(npc_name)
		if npc_entry:
			var label = npc_entry.get_node_or_null("NameLabel")
			var check = npc_entry.get_node_or_null("Check")
			if label:
				label.text = npc_name
			if check:
				check.text = "☑" if talked_to[npc_name] else "☐"
		else:
			print("Warning: Missing UI entry for ", npc_name)

	var total = talked_to.values().count(true)
	total_label.text = "Total NPCs Talked To: %d / %d" % [total, talked_to.size()]

	if total == talked_to.size():
		print("Mission complete!")
		show_mission_complete()


func mark_npc_as_talked(npc_name: String) -> void:
	if npc_name in talked_to:
		talked_to[npc_name] = true
		update_ui()
	else:
		print("Warning: NPC '%s' not found in talked_to dictionary" % npc_name)


func show_mission_complete() -> void:
	print("Showing Mission Complete UI...")

	for child in get_children():
		child.visible = false

	if fade_overlay:
		fade_overlay.visible = true
	else:
		push_warning("FadeOverlay is missing; create a ColorRect named FadeOverlay as a child of MissionPanel.")

	var mission_complete_label = get_node_or_null("MissionCompleteLabel")
	if mission_complete_label:
		mission_complete_label.visible = true
		mission_complete_label.text = "MISSION COMPLETE!"
		mission_complete_label.add_theme_color_override("font_color", Color.WHITE)
	else:
		title_label.visible = true
		mission_label.visible = true
		title_label.text = "MISSION COMPLETE!"
		mission_label.text = "You've talked to everyone!"
		title_label.add_theme_color_override("font_color", Color.WHITE)
		mission_complete_label = null

	if fade_overlay:
		fade_overlay.color.a = 0.0
	if title_label:
		title_label.modulate.a = 0.0
	if mission_label:
		mission_label.modulate.a = 0.0
	if mission_complete_label:
		mission_complete_label.modulate.a = 0.0

	var tween = create_tween()
	if fade_overlay:
		tween.tween_property(fade_overlay, "color:a", 1.0, 1.5)
	if mission_complete_label:
		tween.tween_property(mission_complete_label, "modulate:a", 1.0, 1.0)
	else:
		tween.tween_property(title_label, "modulate:a", 1.0, 1.0)
		tween.tween_property(mission_label, "modulate:a", 1.0, 1.0)

func _on_mission_completed() -> void:
	show_mission_complete()

func fade_to_black(node: ColorRect):
	for i in range(21):
		node.color.a = i / 20.0
		await get_tree().create_timer(0.05).timeout
		
