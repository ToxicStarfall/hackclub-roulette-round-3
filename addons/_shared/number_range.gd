@tool
class_name NumberRange
extends Resource


@export var min_: float = 0.0 : set = _set_min
@export var max_: float = 1.0 : set = _set_max



func _init(min = 0.0, max = 1.0):
	min_ = min
	max_ = max


func _set_min(value: float):
	#print("set min")
	min_ = value
	if min_ > max_:
		max_ = min_


func _set_max(value: float):
	#print("set max")
	max_ = value
	if max_ < min_:
		min_ = max_


## Resets min/max to their default values.
func reset():
	min_ = 0
	max_ = 1


func _property_can_revert(property: StringName) -> bool:
	#property_can_revert()
	print("can rev")
	return false
func _property_get_revert(property: StringName) -> Variant:
	#property_get_revert()
	print("get rev")
	return 
