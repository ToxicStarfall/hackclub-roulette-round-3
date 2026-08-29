class_name Items
extends Node

#enum {
	#GOLD,
	#MEDICINE,
	#FOOD,
	#WATER,
	#WEAPONS,
#}

const GOLD = &"gold_coin"
const FOOD = &"ration"
const BANDAGE = &"bandage"
const MEDICINE = &"bandage"
#const CLOTH = "CLOTH"
#const ROPE = "ROPE"


static func keys():
	#return get_script().get_script_constant_map().keys()
	return [GOLD, FOOD, BANDAGE]
