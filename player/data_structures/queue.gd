class_name Queue extends RefCounted

## Queue data structure. (FIFO)

var _data: Array[Variant] = []
var _front: int = 0
var _tail: int = 0
var _size: int = 0
var _capacity: int = 2


# ---------- PRIVATE ------------ #

func _next_pow2(val: int) -> int:
	val -= 1
	val |= val >> 1
	val |= val >> 2
	val |= val >> 4
	val |= val >> 8
	val |= val >> 16
	val |= val >> 32
	return val + 1

func _data_resize(new_size: int) -> void:
	var ncapacity: int = _next_pow2(new_size + 1)
	var ocapacity: int = _capacity

	var narray: Array[Variant] = []
	narray.resize(ncapacity)
	_capacity = ncapacity

	var of: int = _front
	var ot: int = _tail
	var i: int = 0
	while of != ot:
		narray[i] = _data[of]
		of = (of + 1) % ocapacity
		i += 1
	_data = narray
	_front = 0
	_tail = i

func _init() -> void:
	_data.resize(_capacity)

func dequeue() -> Variant:
	if _front == _tail:
		push_error("Dequeuing empty queue.")
		return null
	var front: Variant = _data[_front]
	_front = (_front + 1) % _capacity
	_size -= 1
	return front

func enqueue(entry: Variant) -> void:
	if ((_tail + 1) % _capacity == _front):
		_data_resize(_capacity)
	_data[_tail] = entry

	# Recalculate due to possible resize.
	_tail = (_tail + 1) % _capacity
	_size += 1

func clear() -> void:
	_front = 0
	_tail = 0
	_size = 0
	_capacity = 2
	_data.clear()
	_data.resize(2)

func resize(new_size: int) -> void:
	_data_resize(new_size)

func size() -> int:
	return _size

func is_empty() -> bool:
	return _size == 0

func at(i: int) -> Variant:
	return _data[(_front + i) % _capacity]
