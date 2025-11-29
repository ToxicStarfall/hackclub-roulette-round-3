class_name CharacterStats
extends Resource


#enum StatType {
	#HEALTH,
	#HUNGER,
	#THIRST,
	#ENERGY,
	#REST
#}

@export var health := 100.0
@export var hunger := 100.0
@export var thirst := 100.0
@export var energy := 100.0
#@export var rest := 100.0

# Average walking speed in km (~3 mph)
@export var walk_speed := 5.0
