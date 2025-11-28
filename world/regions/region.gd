#extends Script
extends Resource
class_name Region


@export var name: String = "Unknown Region"
@export var density: float = 10.0
@export var rainfall: float = 0.5
@export var min_temperature: float = 0.0
@export var avg_temperature: float = 75.0
@export var max_temperature: float = 100.0

#class GRASSLAND:
	#var density = 1.0
	#var temperature_range
	#pass
