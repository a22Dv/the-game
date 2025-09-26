extends Node

## Global game manager. Stores application settings,
## manages scenes, etc. Any persistent application-wide
## data should be found here.

## Keys to values.
enum StateType {
	MASTER_VOLUME,
	MUSIC_VOLUME,
	SFX_VOLUME,
	_STATE_TYPE_COUNT
}

# ---------- PRIVATE ------------ #

var _state: Array = []
var _stack: Stack = Stack.new()

func _ready() -> void:
	_state.resize(StateType._STATE_TYPE_COUNT)
	_state[StateType.MASTER_VOLUME] = 1.0
	_state[StateType.MUSIC_VOLUME] = 1.0
	_state[StateType.SFX_VOLUME] = 1.0
	
# Specifically for dependency inversion as autoloading
# loads GlobalManager before MainMenu. So we need
# MainMenu to "report" its existence to GlobalManager.
func _register(node: Node) -> void:
	_stack.push(node)
	
# ---------- PUBLIC ---------- #

## Pushes a scene on the stack, and pauses the scenes immediately below.
func push_scene(path: String) -> void:
	var pkd_scene: PackedScene = load(path)
	if not pkd_scene or not pkd_scene.can_instantiate():
		push_warning("Error: Path %s cannot be instantiated." % [path])
		return
	var scene: Node = pkd_scene.instantiate()
	if not _stack.is_empty():
		_stack.top().process_mode = ProcessMode.PROCESS_MODE_DISABLED
	_stack.push(scene)
	get_tree().root.add_child(scene)
	
## Pops a scene off a stack and frees it. It then un-pauses the scene below.
func pop_scene() -> void:
	# Popping the first scene results in an empty screen.
	# Call swap_scene() instead if you want to change the first.
	if _stack.size() <= 1:
		push_warning("Error: Cannot pop the first scene on the stack.")
		return
	var crnt_scene: Node = _stack.pop()
	crnt_scene.queue_free()
	_stack.top().process_mode = ProcessMode.PROCESS_MODE_INHERIT

## Gets the current active scene.
func get_current_scene() -> Node:
	return _stack.top()

## Swaps the current active scene.
func swap_scene(path: String) -> void:
	var pckd_scene: PackedScene = load(path)
	if not pckd_scene or not pckd_scene.can_instantiate():
		push_warning("Error: Path %s cannot be instantiated." % [path])
		return
	var scene: Node = pckd_scene.instantiate()
	var crnt_scene: Node = _stack.pop()
	crnt_scene.queue_free()
	_stack.push(scene)
	get_tree().root.add_child(scene)
	
## Gets the value associated with the specified type.
func get_state(type: StateType) -> Variant:
	return _state[type]

## Sets the value associated with the specified type.
func set_state(type: StateType, val: Variant) -> void:
	_state[type] = val
	
## Quits the entire game.
func quit() -> void:
	get_tree().quit()
