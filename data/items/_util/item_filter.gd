class_name ItemFilter
extends Resource


const ITEMS: Registry = Registries.ITEMS

@export_enum("Item", "Consumable", "Weapon", "Armor", ) var item_type: String
@export var required_tags: Array[ItemData.Tags]
#@export


func find():
	var item_ids: Array[StringName]
	
	# Loops through each items' tags in the ITEMS registry.
	item_ids = ITEMS.filter(&"tags", func(tags: Array):
		# For all required tags, check to see if the items' tags has them also.
		return required_tags.all( func(req_tag):
			return tags.has(req_tag)
			)
		)
	
	return item_ids


func is_valid() -> bool:
	var valid = true
	return valid
