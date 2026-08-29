@tool
extends EditorPlugin


var inspector_plugin = preload("res://addons/_shared/number_range_inspector_plugin.gd").new()


func _enter_tree() -> void:
	#print("Loaded")
	add_inspector_plugin( inspector_plugin )
	pass


func _exit_tree() -> void:
	remove_inspector_plugin( inspector_plugin )
	pass
