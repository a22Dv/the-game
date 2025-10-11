extends TextureRect

# Track which NPCs have been talked to
var talked_to = {
	"Jeremih": false,
	"Princess Salazar": false,
	"Samantha 'sammie' Kho": false,
	"Glenn Carew-Gibbs": false,
	"Arvin Provido III": false,
	"Magdaleine Nicole Stalley": false,
}

# Cache UI nodes for faster access
@onready var title_label = $Title
@onready var mission_label = $MissionDescription
@onready var npc_list = $NPCList
@onready var total_label = $TotalLabel

func _ready() -> void:
	title_label.text = "MISSION"
	mission_label.text = "TALK TO 6 PEOPLE"
	update_ui()
	
	if Engine.has_singleton("QuestManager"):
		QuestManager.connect("npc_talked", Callable(self,"_on_npc_talked"))
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

func mark_npc_as_talked(npc_name: String):
	if npc_name in talked_to:
		talked_to[npc_name] = true
		update_ui()
	else:
		print("Warning: NPC '%s' not found in talked_to dictionary" % npc_name)
