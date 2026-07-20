#extends Script
extends Resource
class_name Region


#func _init(new_name, _new_density, new_rainfall ) -> void:
func _init(new_name: String, new_rainfall: float) -> void:
	name = new_name
	rainfall = new_rainfall
	#density = new_density
	pass


@export var name: String = "Unknown Region"
#@export var density: float = 10.0
@export var rainfall: float = 0.5
#@export var rainfall_fluc
#@export var min_temperature: float = 0.0
#@export var avg_temperature: float = 75.0
#@export var max_temperature: float = 100.0
