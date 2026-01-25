class_name Damage
extends Resource


enum Source {
	NONE, BODY, WEAPON,
}
enum Types {
	BASIC,
	# Elemental
}
enum Modifiers {
	NORMAL, PIERCING, BLUNT
}

@export var value: int = 1
#@export var types: Array[Types]
@export var source: Source
#@export var modifiers: Array[Modifiers]
