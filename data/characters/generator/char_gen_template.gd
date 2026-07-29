@tool
class_name CharGenTemplate
extends Resource


@export_range(0,5) var tier: int
@export var attr_points: int = 5
@export var attr_points_per_level: int = 2
#@export var min_attr_level: int = 0
#@export var max_attr_level: int = 5


@export_group("Base Attributes")
@export var base_agility: int = 0  ## Affects your travel speed. Bonuses to situations requiring speed.
@export var base_charisma: int = 0
@export var base_dexterity: int = 0
@export var base_endurance: int = 0
@export var base_intelligence: int = 0
@export var base_strength: int = 0

@export_group("Attribute Weights")
@export var agility: float = 0.0  ## Affects your travel speed. Bonuses to situations requiring speed.
@export var charisma: float = 0.0
@export var dexterity: float = 0.0
@export var endurance: float = 0.0
@export var intelligence: float = 0.0
@export var strength: float = 0.0

@export_group("")
#@export var items: Array[ItemFilter]
@export var items: Array[ItemSelector]



## Returns an array of base attribute levels.
func get_base_attributes() -> Array[int]:
	var attributes: Array = []
	attributes.append(base_agility)
	attributes.append(base_charisma)
	attributes.append(base_dexterity)
	attributes.append(base_endurance)
	attributes.append(base_intelligence)
	attributes.append(base_strength)
	return attributes


## Returns an array of weights for attribute generation.
func get_attr_weights() -> Array[float]:
	var weights: Array = []
	weights.append(agility)
	weights.append(charisma)
	weights.append(dexterity)
	weights.append(endurance)
	weights.append(intelligence)
	weights.append(strength)
	return weights
