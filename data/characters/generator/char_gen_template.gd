@tool
class_name CharGenTemplate
extends Resource


@export_range(0,5) var tier: int
@export var attr_points: int = 5
@export var attr_points_per_level: float = 2
@export var min_attr_level: int = 0
@export var max_attr_level: int = 5

@export_group("Attribute Weights")
@export var agility: float = 0.0  ## Affects your travel speed. Bonuses to situations requiring speed.
@export var charisma: float = 0.0
@export var dexterity: float = 0.0
@export var endurance: float = 0.0
@export var intelligence: float = 0.0
@export var strength: float = 0.0

#@export_group("Items")
@export var items: Array[ItemFilter]
#@export_custom(Registry.PROPERTY_HINT_CUSTOM, "res://data/registries/items.tres,true,true") var items: Array[StringName]
#@export var quantities: Array[int]


func get_attr_weights() -> Array[float]:
	var weights: Array = []
	weights.append(agility)
	weights.append(charisma)
	weights.append(dexterity)
	weights.append(endurance)
	weights.append(intelligence)
	weights.append(strength)
	return weights



class ItemFilter extends Resource:
	@export_enum("Item", "Consumable", "Weapon", "Armor", ) var item_type: String
	@export var item_tags: Array[ItemData.Tags]
	#@export 
	pass
