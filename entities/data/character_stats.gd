extends Resource
#extends Entity
class_name CharacterStats


@export var health := 100.0
@export var hunger := 100.0
@export var thirst := 100.0
@export var energy := 100.0
@export var rest := 100.0

# Average walking speed in km (~3 mph)
@export var walk_speed := 5.0

#@export_subgroup("A")
#@export var name: String = "Unknown Survivor"
#@export_range(20, 60) var age: int = 20
#@export var background: Backgrounds
#@export var traits: Array = []
#@export var intelligence = 10
