class_name CharacterPreset
extends Resource


@export var enabled: bool = true  ## If false, this character preset will be hidden and unavailable.

@export var name: String
@export_multiline("This character's background") var description: String
#@export_range(20, 60) var age: int = 20

@export_group("Attributes")
#@export var min_attr_level: int = 1
#@export var max_attr_level: int = 5
@export var agility: int = 3  ## Affects your travel speed. Bonuses to situations requiring speed.
@export var charisma: int = 3
@export var dexterity: int = 3
@export var endurance: int = 3
@export var intelligence: int = 3
@export var strength: int = 3

@export_group("")
#@export_group("Items")
#@export var items: Dictionary[ItemData, int]
#@export var items: Array[ItemSet]
@export_custom(Registry.PROPERTY_HINT_CUSTOM, "res://data/registries/items.tres,true,true") var items: Array[StringName]
#@export var quantities: Array[int]
@export_range(0, 100) var quantities: Array[int]
