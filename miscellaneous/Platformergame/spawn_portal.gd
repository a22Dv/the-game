extends Area2D

@export var landing_zone: Area2D


func _process(delta: float) -> void:
	pass
	
#check 
func _on_body_entered(body: Node2D) -> void:
	print('test', body)
