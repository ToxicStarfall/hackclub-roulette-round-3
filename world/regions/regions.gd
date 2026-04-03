extends Node


var Desert = Region.new("Desert", 0.3)
# var Plains = Region.new("Plains", 0.4)
var Grasslands = Region.new("Grasslands", 0.45)
var Woodlands = Region.new("Woodlands", 0.5)
var Forest = Region.new("Forest", 0.55)
# var Rainforest = Region.new("Rainforest", 0.7)


var is_desert = false
var is_grasslands = false
var is_forest = false



#func _ready() -> void:
	#Events.location_changed.connect( _on_region_changed )


#func _on_region_changed(region: Region):
	#set("is_%s" % [region.name.to_lower()], "a")


func is_in(region: Region) -> bool:
	return Game.current_location == region


#func is_desert() -> bool:
	#return Game.current_location == Desert
#
#func is_grasslands() -> bool:
	#return Game.current_location == Grasslands
#
#func is_forest() -> bool:
	#return Game.current_location == Forest
