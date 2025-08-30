class_name Event
extends Resource


#signal event_entered
#signal event_exited

#@export var type: Types = EventTypes.NORMAL
@export var title: String = ""
@export var dialogue: Array[BaseDialogue] = []
#@export var dialogues: Array[Dialogue] = []
#@export var paths: Dictionary[String, BaseDialogue] = {}
@export var paths: Array[BaseDialogue] = []


#func exit():
	# Do stuff after event ends
	#   Apply effects, etc...
	#event_exited.emit()
