class_name EncounterEvent
extends Event


#@export var options: Dictionary[int, String] = {}
@export var options: Array[EventOption] = []
## If true, automatically adds a "Ignore" option.
@export var ignoreable: bool = false
@export var a: JSON


func exit():
	# Do stuff after event ends
	#   Apply effects, etc...
	event_exited.emit()
