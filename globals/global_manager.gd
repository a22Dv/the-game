extends Node

## Global game manager. Stores application settings,
## manages scenes, etc. Any persistent application-wide
## data should be found here.

enum StateType {
	MASTER_VOLUME,
	MUSIC_VOLUME,
	SFX_VOLUME,
	_STATE_TYPE_COUNT
}

# ---------- PRIVATE ------------ #

var _state: Array = []
var _stack: Array[Node] = []

func _ready() -> void:
	_state.resize(StateType._STATE_TYPE_COUNT)
	_state[StateType.MASTER_VOLUME] = 1.0
	_state[StateType.MUSIC_VOLUME] = 1.0
	_state[StateType.SFX_VOLUME] = 1.0
	
# Specifically for dependency inversion as autoloading
# loads GlobalManager before MainMenu. So we need
# MainMenu to "report" its existence to GlobalManager.
func _register(node: Node) -> void:
	_stack.push_back(node)
	
# ---------- PUBLIC ---------- #

func push_scene(path: String) -> void:
	var pkd_scene: PackedScene = load(path)
	if not pkd_scene or not pkd_scene.can_instantiate():
		push_warning("Error: Path %s cannot be instantiated." % [path])
		return
	var scene: Node = pkd_scene.instantiate()
	if not _stack.is_empty():
		_stack.back().process_mode = ProcessMode.PROCESS_MODE_DISABLED
	_stack.push_back(scene)
	get_tree().root.add_child(scene)
	
	
func pop_scene() -> void:
	# Popping the first scene results in an empty screen.
	# Call swap_scene() instead if you want to change the first.
	if _stack.size() <= 1:
		push_warning("Error: Cannot pop the first scene on the stack.")
		return
	var crnt_scene: Node = _stack.pop_back()
	crnt_scene.queue_free()
	_stack.back().process_mode = ProcessMode.PROCESS_MODE_INHERIT

func get_current_scene() -> Node:
	return _stack.back()

func swap_scene(path: String) -> void:
	var pckd_scene: PackedScene = load(path)
	if not pckd_scene or not pckd_scene.can_instantiate():
		push_warning("Error: Path %s cannot be instantiated." % [path])
		return
	var scene: Node = pckd_scene.instantiate()
	var crnt_scene: Node = _stack.pop_back()
	crnt_scene.queue_free()
	_stack.push_back(scene)
	get_tree().root.add_child(scene)
	
func get_state(type: StateType) -> Variant:
	return _state[type]

func set_state(type: StateType, val: Variant) -> void:
	_state[type] = val
	
func quit() -> void:
	get_tree().quit()
