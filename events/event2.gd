class_name Event2
extends Resource

#signal dialogue_progressed

#@export var type: Types = EventTypes.NORMAL

var id: String
@export var title: String = ""
#@export var texture: Texture2D
#@export var description: String = ""
#@export var dialogue: DialogueResource

@export_category("Configuration")
#@export var regions: Array[Region]


#func exit():
	# Do stuff after event ends
	#   Apply effects, etc...
	#event_exited.emit()
