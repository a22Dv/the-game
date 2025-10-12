extends CharacterBody2D

#rng for customer skin variants
var rng := RandomNumberGenerator.new()
var skinrng = rng.randi_range(1, 5)

func _ready() -> void:
	
	change_sprite_standing()
	
	#staring position for customers
	position = Vector2(300, 288) 
		
	
	
	
	

func change_sprite_standing ():
	var skinstand: String = "res://assets/cafe/customers/stand/customer" + str(skinrng) + ".png"
	$Sprite2D.texture = load(skinstand)
	
func change_sprite_sitting ():
	var skinsit: String = "res://assets/cafe/customers/sit/sit" + str(skinrng) + ".png"
	$Sprite2D.texture = load(skinsit)
	
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("sitting area"):
		print("seat entered")
	print("body entered")
	print(body)
