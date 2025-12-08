class_name CharacterStats
extends Resource


#const HEALTH = "health"
#const HUNGER = "hunger"
#const THIRST = "thirst"
#const ENERGY = "energy"
#const REST = "rest"


@export var health := 100.0
@export var hunger := 100.0
@export var thirst := 100.0
@export var energy := 100.0
#@export var rest := 100.0

@export var sanity := 100.0

@export var charisma := 10.0
@export var dexterity := 10.0
@export var intelligence := 10.0

# Average movement speed in kilometres(km)
@export var walk_speed := 5.0  # (~3.0 mph)
@export var run_speed := 12.5  # (~7.5 mph)
