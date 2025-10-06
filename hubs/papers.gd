
extends Node2D

# hover variables
var normal_texture = preload("res://assets/papers/clip.png")
var hover_right    = preload("res://assets/papers/new right.png")
var hover_left     = preload("res://assets/papers/new left.png")

# pages
var current_page := 1
var total_pages := 3

# stamp variables
var dragging := false
var dragged_stamp: Sprite2D = null
var stamp_start_pos := Vector2.ZERO

var stamp_ref: Sprite2D
var stamp_original_parent: Node = null
var stamp_original_pos: Vector2 = Vector2.ZERO

# wise code management? sorry idk how to do that i only know how to do what works ¯\_(ツ)_/¯

func _ready():
	#
	randomize()
	randi()
	
	$clip.texture = normal_texture
	
	#right side hover animation
	$clip/Turnright.mouse_entered.connect(_on_hover_right)
	$clip/Turnright.mouse_exited.connect(_on_hover_end)
	
	#left side hover animation
	$clip/Turnleft.mouse_entered.connect(_on_hover_left)
	$clip/Turnleft.mouse_exited.connect(_on_hover_end)
	
	_show_page(current_page)
	$clip/Turnright.input_event.connect(_on_turn_right)
	$clip/Turnleft.input_event.connect(_on_turn_left)
	
	# stamp shit
	$GreenStamp/Area2D.input_event.connect(_on_stamp_drag_event.bind($GreenStamp))
	$RedStamp/Area2D.input_event.connect(_on_stamp_drag_event.bind($RedStamp))
	
	# Clip PAGE 1 _____________________________________________________________________________________
	# Array for textures
	var org_textures = [
		"res://assets/papers/clipboard/Page 1/Writers guild.png",
		"res://assets/papers/clipboard/Page 1/Debutistas.png",
        "res://assets/papers/clipboard/Page 1/FirstAid.png"
	]
	
	var title_textures = [
		"res://assets/papers/clipboard/Page 1/Activity Fair.png",
		"res://assets/papers/clipboard/Page 1/Art Show.png",
        "res://assets/papers/clipboard/Page 1/Acquaintance Party.png"
	]
	
	var act1_textures = [
		"res://assets/papers/clipboard/Page 1/Act 1.png",
		"res://assets/papers/clipboard/Page 1/Act 1 two.png",
		"res://assets/papers/clipboard/Page 1/Act 1 three.png"
	]
	
	var act2_textures = [
		"res://assets/papers/clipboard/Page 1/Act 2.png",
		"res://assets/papers/clipboard/Page 1/Act 2 two.png",
		"res://assets/papers/clipboard/Page 1/Act 2 three.png"
	]
	
	var act3_textures = [
		"res://assets/papers/clipboard/Page 1/Act 3.png",
		"res://assets/papers/clipboard/Page 1/Act 3 three.png"
	]

	# randomly picks
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
	
	# Clip PAGE 1 END_____________________________________________________________________________________
	
	# Clip PAGE 2 _____________________________________________________________________________________
	var date_textures = [
		"res://assets/papers/clipboard/Page 2/Trinbday.png",
		"res://assets/papers/clipboard/Page 2/icebday.png",
		"res://assets/papers/clipboard/Page 2/ianbday.png",
		"res://assets/papers/clipboard/Page 2/enzobday.png",
		"res://assets/papers/clipboard/Page 2/ellambday.png",
		"res://assets/papers/clipboard/Page 2/ellabbday.png"
	]
	
	var time_textures = [
		"res://assets/papers/clipboard/Page 2/time1.png",
		"res://assets/papers/clipboard/Page 2/time2.png",
		"res://assets/papers/clipboard/Page 2/time3.png",
		"res://assets/papers/clipboard/Page 2/time4.png"
	]
	
	var budget_textures = [
		"res://assets/papers/clipboard/Page 2/budget1.png",
		"res://assets/papers/clipboard/Page 2/budget2.png",
		"res://assets/papers/clipboard/Page 2/budget3.png",
		"res://assets/papers/clipboard/Page 2/budget4.png"
	]
	
	var true_date = load(date_textures.pick_random())
	var true_time = load(time_textures.pick_random())
	var true_budget = load(budget_textures.pick_random())
	
	$clip/Page2/Date.texture = true_date
	$clip/Page2/Time.texture = true_time
	$clip/Page2/Budget.texture = true_budget
	
	# Clip PAGE 2 END_____________________________________________________________________________________

	# Paper PAGE 1_____________________________________________________________________________________
	
	var orgfake_textures = [
		"res://assets/papers/Paper/Page1/Paper Org1.png",
		"res://assets/papers/Paper/Page1/Paper Org2.png",
        "res://assets/papers/Paper/Page1/Paper Org3.png"
	]

	var titlefake_textures = [
		"res://assets/papers/Paper/Page1/Paper Title1.png",
		"res://assets/papers/Paper/Page1/Paper Title2.png",
        "res://assets/papers/Paper/Page1/Paper Title3.png"
	]

	var fake_org = load(orgfake_textures.pick_random())
	var fake_title = load(titlefake_textures.pick_random())

	$Paper/Page1/OrgFake.texture = fake_org
	$Paper/Page1/TitleFake.texture = fake_title
	
	# Paper PAGE 1 END_____________________________________________________________________________________
	
	# Paper PAGE 2_____________________________________________________________________________________
	
	var tfake_textures = [
		"res://assets/papers/Paper/Page2/Paper p2 title1.png",
		"res://assets/papers/Paper/Page2/Paper p2 title2.png",
        "res://assets/papers/Paper/Page2/Paper p2 title3.png"
	]
	
	var act1fake_textures = [
		"res://assets/papers/Paper/Page2/Paper act1.png",
		"res://assets/papers/Paper/Page2/Paper act2.png",
		"res://assets/papers/Paper/Page2/Paper act3.png"
	]
	
	var act2fake_textures = [
		"res://assets/papers/Paper/Page2/Paper 2act1.png",
		"res://assets/papers/Paper/Page2/Paper 2act2.png",
		"res://assets/papers/Paper/Page2/Paper 2act3.png"
	]
	
	var datefake_textures = [
		"res://assets/papers/Paper/Page2/Paper d1.png",
		"res://assets/papers/Paper/Page2/Paper d2.png",
		"res://assets/papers/Paper/Page2/Paper d3.png",
		"res://assets/papers/Paper/Page2/Paper d4.png",
		"res://assets/papers/Paper/Page2/Paper d5.png",
		"res://assets/papers/Paper/Page2/Paper d6.png"
	]
	
	var timefake_textures = [
		"res://assets/papers/Paper/Page2/Paper Time1.png",
		"res://assets/papers/Paper/Page2/Paper Time2.png",
		"res://assets/papers/Paper/Page2/Paper Time3.png",
		"res://assets/papers/Paper/Page2/Paper Time4.png"
	]
	
	var fake_t = load(tfake_textures.pick_random())
	var fake_a1 = load(act1fake_textures.pick_random())
	var fake_a2 = load(act2fake_textures.pick_random())
	var fake_date = load(datefake_textures.pick_random())
	var fake_time = load(timefake_textures.pick_random())

	$Paper/Page2/Titlesfake.texture = fake_t
	$Paper/Page2/actfake.texture = fake_a1
	$Paper/Page2/act2fake.texture = fake_a2
	$Paper/Page2/Date.texture = fake_date
	$Paper/Page2/Time.texture = fake_time
	
	# Paper PAGE 2 END_____________________________________________________________________________________
	
	# Paper PAGE 3_____________________________________________________________________________________
	
	var prevdate_textures = [
		"res://assets/papers/Paper/Page3/Prev Date1.png",
		"res://assets/papers/Paper/Page3/Prev Date2.png",
		"res://assets/papers/Paper/Page3/Prev Date3.png",
		"res://assets/papers/Paper/Page3/Prev Date4.png",
		"res://assets/papers/Paper/Page3/Prev Date5.png",
		"res://assets/papers/Paper/Page3/Prev Date6.png"
	]
	
	var p3title_textures = [
		"res://assets/papers/Paper/Page3/Another title1.png",
		"res://assets/papers/Paper/Page3/Another title2.png",
		"res://assets/papers/Paper/Page3/Another title3.png"
	]
	
	var act1p3_textures = [
		"res://assets/papers/Paper/Page3/More Act1.png",
		"res://assets/papers/Paper/Page3/More Act2.png",
		"res://assets/papers/Paper/Page3/More Act3.png"
	]
	
	var act2p3_textures = [
		"res://assets/papers/Paper/Page3/More 2Act1.png",
		"res://assets/papers/Paper/Page3/More 2Act2.png",
		"res://assets/papers/Paper/Page3/More 2Act3.png"
	]
	
	var budgetfake_textures = [
		"res://assets/papers/Paper/Page3/FakeBudget1.png",
		"res://assets/papers/Paper/Page3/FakeBudget2.png",
		"res://assets/papers/Paper/Page3/FakeBudget3.png",
		"res://assets/papers/Paper/Page3/FakeBudget4.png"
	]
	
	var prevdate = load(prevdate_textures.pick_random())
	var moretitle = load(p3title_textures.pick_random())
	var page3act1 = load(act1p3_textures.pick_random())
	var page3act2 = load(act2p3_textures.pick_random())
	var fakebudget = load(budgetfake_textures.pick_random())
	
	$Paper/Page3/PrevDate.texture = prevdate
	$Paper/Page3/NotherTitle.texture = moretitle
	$Paper/Page3/Act1.texture = page3act1
	$Paper/Page3/Act2.texture = page3act2
	$Paper/Page3/Budget.texture = fakebudget
	
	# Paper PAGE 3 END_____________________________________________________________________________________
	
#hover functions
func _on_hover_right() -> void:
	if current_page < total_pages:
		$clip.texture = hover_right

func _on_hover_left() -> void:
	if current_page > 1:
		$clip.texture = hover_left

func _on_hover_end() -> void:
		$clip.texture = normal_texture

#turn functions
func _show_page(page_num: int):
	
	var clip = $clip
	
	# Hide all pages first
	for child in clip.get_children():
		if child.name.begins_with("Page"):
			child.visible = false
	
	# Show the requested page
	var page_node = clip.get_node_or_null("Page%d" % page_num)
	if page_node:
		page_node.visible = true

func _on_turn_right(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_page < total_pages:
			current_page += 1
			_show_page(current_page)

func _on_turn_left(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_page > 1:
			current_page -= 1
			_show_page(current_page)
			
# drag functions_____________________________________________________________________________________
func _on_stamp_drag_event(_viewport: Node, event: InputEvent, _shape_idx: int, stamp: Sprite2D) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = true
		dragged_stamp = stamp
		stamp_start_pos = stamp.position
	
func _process(_delta):
	if dragging and dragged_stamp:
		dragged_stamp.position = get_viewport().get_mouse_position()
		
func _input(event):
	if dragging and event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Only proceed if over the Paper's StampZone
		if $Paper/StampZone.get_overlapping_areas().size() > 0:
			# choose texture for the dragged stamp
			var stamp_texture: Texture2D = null
			if dragged_stamp == $GreenStamp:
				stamp_texture = load("res://assets/papers/stampmark green.png")
			elif dragged_stamp == $RedStamp:
				stamp_texture = load("res://assets/papers/stampmark red.png")

			if stamp_texture != null:
				# respawn the stamp visually
				reset_stamp(dragged_stamp)

				# detect which page the mouse is over on release
				var release_pos := get_global_mouse_position()
				var target_page: Node2D = get_page_at_global_pos(release_pos)

				# fallback: if nothing found, pick first visible page (keeps previous behaviour)
				if target_page == null:
					for child in $Paper.get_children():
						if child.name.begins_with("Page") and child.visible:
							target_page = child
							break

				if target_page:
					stamp_paper(stamp_texture, target_page)
					move_page(target_page)
				else:
					pass
		else:
			# not over stamp zone -> return stamp to holder
			var tween = create_tween()
			tween.tween_property(dragged_stamp, "position", stamp_start_pos, 0.3)

		dragging = false
		dragged_stamp = null

func reset_stamp(stamp: Sprite2D):
	stamp.visible = true
	var tween = create_tween()
	tween.tween_property(stamp, "position", stamp_start_pos, 0.3)
	
# tweening animation__________________________________________________________________________________________

func stamp_paper(stamp_texture: Texture2D, page: Node2D):
	stamp_ref = $Paper/StampMark
	stamp_original_parent = stamp_ref.get_parent()
	stamp_original_pos = stamp_ref.position

	# Use global position before reparenting
	var global_pos = stamp_ref.global_position

	stamp_ref.texture = stamp_texture
	stamp_ref.reparent(page)

	stamp_ref.global_position = global_pos


func move_page(page: Node2D):
	var tween = create_tween()
	var target_pos = page.position + Vector2(0, -600)

	tween.tween_property(page, "position", target_pos, 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

	tween.tween_callback(func ():
		stamp_ref.texture = null
		stamp_ref.reparent(stamp_original_parent)
		stamp_ref.position = stamp_original_pos
	)

func get_page_at_global_pos(pos: Vector2) -> Node2D:

	var kids = $Paper.get_children()
	for i in range(kids.size() - 1, -1, -1):
		var child = kids[i]
		if not child.name.begins_with("Page"):
			continue
		if not child.visible:
			continue

		var paper_sprite := child.get_node_or_null("Paper2")
		if paper_sprite == null:
			continue
		if paper_sprite.texture == null:
			continue
		var tex_size: Vector2 = paper_sprite.texture.get_size() * paper_sprite.scale
		var top_left: Vector2 = paper_sprite.global_position

		if paper_sprite.centered:
			top_left -= tex_size * 0.5
		var rect := Rect2(top_left, tex_size)
		if rect.has_point(pos):
			return child
	return null
