extends Node

signal mission_completed
signal npc_talked(npc_name: String)

var mission_complete := false
var talked_to_npcs := {}
var current_mode := ""

var required_npcs_easy := [
	"Jeremih",
	"Princess Salazar",
	"Samantha 'sammie' Kho",
	"Glenn Carew-Gibbs",
	"Magdaleine Nicole Stalley",
	"Another NPC"
]

var required_npcs_medium := [
	"Edwin Gutierrez",
	"Ysabelle Sanchez",
	"Celeste De la Torre"
]

func set_mode(mode: String):
	current_mode = mode
	talked_to_npcs.clear()
	mission_complete = false

	var npcs = _get_required_npcs()
	for name in npcs:
		register_npc(name)

	print("QuestManager set to mode:", current_mode, "with NPCs:", npcs)


func _get_required_npcs() -> Array:
	if current_mode == "medium":
		return required_npcs_medium
	else:
		return required_npcs_easy


func register_npc(name: String):
	talked_to_npcs[name] = false


func npc_talked_to(name: String):
	if mission_complete:
		return

	if name in talked_to_npcs:
		talked_to_npcs[name] = true
		print("%s marked as talked to in QuestManager" % name)
		emit_signal("npc_talked", name)
		_check_mission_status()
	else:
		print("NPC '%s' not part of current mission (%s)" % [name, current_mode])


func _check_mission_status():
	if talked_to_npcs.values().all(func(v): return v):
		mission_complete = true
		print("Mission Complete for %s mode!" % current_mode)
		emit_signal("mission_completed")


func connect_dialogue(npc):
	print("Connected dialogue for:", npc.npc_name)
