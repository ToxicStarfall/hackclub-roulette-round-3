class_name StatusEffect
extends Resource


@export var icon: Texture2D
@export var name: String
@export_multiline() var description: String
@export var duration: float = 1.0  ## Duration in in-game hours. -1 means infinite duration.

@export var attribute_effect: CharacterData.Attribute
#@export var attribute_base_effect: float = 1.0
@export var efficiency_effect: CharacterData.Efficiency
#@export var efficiency_base_effect: float = 1.0

#@export var effects: Array
@export var levels: Array[StatusEffectLevel]

var current_level
