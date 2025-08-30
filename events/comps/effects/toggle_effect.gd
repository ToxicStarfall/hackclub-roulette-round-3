class_name ToggleEffect
extends Effect


@export var toggle: String = ""
@export var value: bool = false

func apply():
	if Game.toggles.get(toggle):
		Game.toggles.set(toggle, value)
		print("Asf")
	#if chance_check():
		#EventManager.dialogue_requested.emit("", outcome_1)
	#else:
		#EventManager.dialogue_requested.emit("", outcome_2)
