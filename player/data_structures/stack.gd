class_name Stack extends RefCounted

##  Stack data structure. Wrapper around Array[]

var _data: Array[Variant] = []

func _init() -> void:
	pass

func size() -> int:
	return _data.size()

func is_empty() -> bool:
	return _data.is_empty()

func push(value: Variant) -> void:
	_data.push_back(value)
	
func pop() -> Variant:
	return _data.pop_back()

func top() -> Variant:
	return _data.back()

func clear() -> void:
	_data.clear()
