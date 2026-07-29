class_name Body
extends Resource


enum FunctionMode {
	WHITELIST, BLACKLIST
}
enum Functions {
	NONE, SIGHT, HEARING, TALKING, MANIPULATION, MOVEMENT, CARRYING
}


@export var function_mode: FunctionMode = FunctionMode.WHITELIST
@export var enabled_functions: Array[Functions]
@export var disabled_functions: Array[Functions]

#@export var parts: Array[BodyPart]
@export var parts: Dictionary[StringName, BodyPart]


func get_efficiency(function: Functions) -> float:
	var efficiency: float
	#for part in parts:
	return efficiency
