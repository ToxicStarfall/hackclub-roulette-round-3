class_name Items
extends Node

#enum {
	#GOLD,
	#MEDICINE,
	#FOOD,
	#WATER,
	#WEAPONS,
#}

const GOLD = "GOLD"
const FOOD = "FOOD"
const MEDICINE = "MEDICINE"
#const CLOTH = "CLOTH"
#const ROPE = "ROPE"


func keys():
	return get_script().get_script_constant_map().keys()
	#return ["Gold", "Food", "Medicine"]
