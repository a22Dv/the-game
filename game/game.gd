extends Node2D

func _on_button_button_down() -> void:
	GlobalManager.pop_scene()

func _ready():
	var q: Queue = Queue.new()
	for i in range(5):
		q.enqueue(i)
	for i in range(3):
		q.dequeue()
	for i in range(6):
		q.enqueue(i)
	while not q.empty():
		print("%d" % [q.dequeue()])
	
		
		
