extends Node

var total_npcs := 6
var talked_to_npcs := {}
var mission_complete := false

signal mission_completed
signal npc_talked(npc_name: String) 

func register_npc(name: String):
	talked_to_npcs[name] = false

func npc_talked_to(name: String):
	if not mission_complete and name in talked_to_npcs:
		talked_to_npcs[name] = true
		print("%s marked as talked to in QuestManager" % name)
		emit_signal("npc_talked", name)
		_check_mission_status()

func _check_mission_status():
	if talked_to_npcs.values().all(func(v): return v):
		mission_complete = true
		emit_signal("mission_completed")
		print("Mission Complete! You talked to everyone")
		
func connect_dialogue(npc):
	print("Connected dialogue for:", npc.npc_name)
