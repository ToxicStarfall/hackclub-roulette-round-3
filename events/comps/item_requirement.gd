class_name ItemRequirement
extends Requirement


enum Comparers {
	BIGGER_THEN,
	BIGGER_OR_EQUAL,
	EQUAL,
	NOT_EQUAL,
	SMALLER_THEN,
	SMALLER_OR_EQUAL,
}

@export var item: Game.Items
@export var value: int = 1
@export var comparer: Comparers = Comparers.BIGGER_OR_EQUAL


func check():
	var valid = true
	if comparer == Comparers.BIGGER_OR_EQUAL:
		#if
		pass
