## Base Effect class. This does NOTHING on its own.
class_name Effect
extends Resource

enum Modifiers {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}
#@export_enum("Inventory:inventory", "Stats:stats", "Toggles:toggles") var a

@export var chance: float = 1.0
#@export var outcome_path: String = ""
@export var outcome_1: Dialogue
@export var outcome_2: Dialogue
#@export var outcome_dialogue: Dialogue

func apply():
	pass


func chance_check():
	return randf() >= chance
