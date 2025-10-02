
extends Node2D

var normal_texture = preload("res://assets/papers/clip.png")
var hover_right    = preload("res://assets/papers/new right.png")
var hover_left     = preload("res://assets/papers/new left.png")

func _ready():
	#
	randomize()
	randi()
	
	$clip.texture = normal_texture
	
	#right side
	$clip/Turnright.mouse_entered.connect(_on_hover_right)
	$clip/Turnright.mouse_exited.connect(_on_hover_end)
	
	#left side
	$clip/Turnleft.mouse_entered.connect(_on_hover_left)
	$clip/Turnleft.mouse_exited.connect(_on_hover_end)
	
	# Array for textures
	var org_textures = [
		"res://assets/papers/Page 1/Writers guild.png",
		"res://assets/papers/Page 1/Debutistas.png",
        "res://assets/papers/Page 1/FirstAid.png"
	]
	
	var title_textures = [
		"res://assets/papers/Page 1/Activity Fair.png",
		"res://assets/papers/Page 1/Art Show.png",
        "res://assets/papers/Page 1/Acquaintance Party.png"
	]
	
	var act1_textures = [
		"res://assets/papers/Page 1/Act 1.png",
		"res://assets/papers/Page 1/Act 1 two.png",
		"res://assets/papers/Page 1/Act 1 three.png"
	]
	
	var act2_textures = [
		"res://assets/papers/Page 1/Act 2.png",
		"res://assets/papers/Page 1/Act 2 two.png",
		"res://assets/papers/Page 1/Act 2 three.png"
	]
	
	var act3_textures = [
		"res://assets/papers/Page 1/Act 3.png",
		"res://assets/papers/Page 1/Act 3 two.png",
		"res://assets/papers/Page 1/Act 3 three.png"
	]

	# randomly picker
	var true_org = load(org_textures.pick_random())
	var true_title = load(title_textures.pick_random())
	var true_act1 = load(act1_textures.pick_random())
	var true_act2 = load(act2_textures.pick_random())
	var true_act3 = load(act3_textures.pick_random())

	# Apply to sprite
	$clip/Page1/OrgTruth.texture = true_org
	$clip/Page1/TitleTruth.texture = true_title
	$clip/Page1/Act1.texture = true_act1
	$clip/Page1/Act2.texture = true_act2
	$clip/Page1/Act3.texture = true_act3


func _on_hover_right() -> void:
	$clip.texture = hover_right

func _on_hover_left() -> void:
	$clip.texture = hover_left

func _on_hover_end() -> void:
		$clip.texture = normal_texture
