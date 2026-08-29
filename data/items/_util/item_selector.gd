@tool
class_name ItemSelector
extends Resource


#@export_group("")
#@export_custom(PROPERTY_HINT_GROUP_ENABLE)

@export_custom(Registry.PROPERTY_HINT_CUSTOM, "res://data/registries/items.tres,true,false") 
var item: StringName
@export var filter: ItemFilter
#@export_range(0,0,1.0,"or_greater") var quantity: int
@export var quantity_min: int: set = _set_quantity_min
@export var quantity_max: int: set = _set_quantity_max
#@export var quantity_curve: Curve: set = _set_quantity_curve  # Quantity of items varies on x axis. Probability is on y axis.



func is_valid() -> bool:
	var valid = false
	#if (item or filter) and quantity > 0:
	if (item or filter):
		valid = true
	return valid


func get_item() -> StringName:
	var item_id: StringName
	if filter:
		item_id = filter.find().pick_random()
	elif item:
		item_id = item
	return item_id


func get_quantity() -> int:
	var quantity: int = randi_range(quantity_min, quantity_max)
	return quantity



#region # ======== SETTERS ======== #

func _set_quantity_min(minimum: int = 1):
	quantity_min = max(minimum, 0)
	
	if quantity_min > quantity_max:
		quantity_max = quantity_min


func _set_quantity_max(maximum: int = 1):
	quantity_max = max(maximum, 0)
	
	if quantity_max < quantity_min:
		quantity_min = quantity_max


#func _set_quantity_curve(curve: Curve):
	#quantity_curve = curve

#endregion
