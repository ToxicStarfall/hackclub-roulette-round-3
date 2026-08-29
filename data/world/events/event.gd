class_name Event
extends Resource


#signal dialogue_progressed

#@export var type: Types = EventTypes.NORMAL

var id: String
@export var title: String = ""
#@export var texture: Texture2D
#@export var description: String = ""
@export var dialogue: DialogueResource


@export_category("Configuration")
#@export var regions: Array[Region]

#@export_custom(Registry.PROPERTY_HINT_CUSTOM, "res://data/registries/regions.tres,true,false") var region_blacklist: Array[StringName]

#@export var region_blacklist: Region


#func _init() -> void:
	#if dialogue == null:
		#if DirAccess.dir_exists_absolute("res://events/dialogue/"):
			##print( FileAccess.file_exists("res://events/dialogue/%" % [resource_path.get_file()]) )
			#print("as")
			#print(title)
			#print(resource_path.get_file())
			##var dialogues = DirAccess.get_files_at("res://events/dialogue/")
	#pass


#func exit():
	# Do stuff after event ends
	#   Apply effects, etc...
	#event_exited.emit()
