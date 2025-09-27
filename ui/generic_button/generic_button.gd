extends Button

func _ready() -> void:
	self.custom_minimum_size.x = 50
	self.custom_minimum_size.y = 100
	self.grow_horizontal = Control.GROW_DIRECTION_BOTH
	self.grow_vertical = Control.GROW_DIRECTION_BOTH
	pass
