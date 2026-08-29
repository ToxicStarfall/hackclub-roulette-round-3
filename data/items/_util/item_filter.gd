class_name ItemFilter
extends Resource


const ITEMS: Registry = Registries.ITEMS

#@export var min_tier: int = 0
#@export var max_tier: int = 3
@export_enum("Item", "Consumable", "Weapon", "Armor", ) var item_type: String
@export var required_slot_type: ItemData.SlotType
@export var required_tags: Array[ItemData.Tags]
#@export_custom(Registry.PROPERTY_HINT_CUSTOM, "res://data/registries/tags.tres,true,false") var required_tags: Array[StringName]


func find():
	var item_ids: Array[StringName]
	
	### Loops through each items' slot type in the ITEMS registry.
	#item_ids = ITEMS.filter(&"slot_type", func(slot_type: ItemData.SlotType):
		#return slot_type == required_slot_type
		#)
	#
	### Loops through each items' tags in the ITEMS registry.
	#item_ids = ITEMS.filter(&"tags", func(tags: Array):
		## For all required tags, check to see if the items' tags has them also.
		#return required_tags.all( func(req_tag):
			#return tags.has(req_tag)
			#)
		#)
	
	item_ids = ITEMS.where({
		&"enabled":
			func (e): return e == true,
		&"slot_type": func(slot_type):
			if required_slot_type:
				return required_slot_type == slot_type
			else:
				return true,
		&"tags": func(tags: Array):
			# For all required tags, check to see if the items' tags has them also.
			return required_tags.all( func(req_tag):
				return tags.has(req_tag)
			)
	})
	
	return item_ids


func is_valid() -> bool:
	var valid = true
	return valid
