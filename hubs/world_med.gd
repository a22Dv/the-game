extends Node

func _ready():
	if QuestManager:
		QuestManager.set_mode("medium")
