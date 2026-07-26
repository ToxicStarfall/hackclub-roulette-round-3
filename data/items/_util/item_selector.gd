@tool
class_name ItemSelector
extends Resource


#@export_group("")
#@export_custom(PROPERTY_HINT_GROUP_ENABLE)

@export_custom(Registry.PROPERTY_HINT_CUSTOM, "res://data/registries/items.tres,true,false") 
var item: StringName
#@export var item: ItemFilter
@export var group: ItemFilter
@export_range(0,0,1.0,"or_greater") var quantity: int
@export var quantity_min: int: set = _set_quantity_min
@export var quantity_max: int: set = _set_quantity_max
#@export var quantity_curve: Curve: set = _set_quantity_curve  # Quantity of items varies on x axis. Probability is on y axis.


func is_valid() -> bool:
	var valid = false
	if (item or group) and quantity > 0:
		valid = true
	return valid



#func _set_quantity_curve(curve: Curve):
	#quantity_curve = curve

func _set_quantity_min(minimum: int):
	quantity_min = minimum
	pass


func _set_quantity_max(maximum: int):
	quantity_max = maximum
	pass
