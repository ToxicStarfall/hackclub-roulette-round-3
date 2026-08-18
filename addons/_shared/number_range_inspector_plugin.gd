@tool
extends EditorInspectorPlugin



func _can_handle(object: Object) -> bool:
	#if object is NumberRange:
		return true
	#else:
		#return false
	

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	#print(object)
	#print(type)
	#print(name)  # property name
	#print(hint_type)
	#print(hint_string)  # type name
	#print(usage_flags)
	#print(wide)
	#print(" ")
	
	#if object is NumberRange:
	if hint_string == "NumberRange":
		var editor: EditorProperty = preload("res://addons/_shared/editor_property.tscn").instantiate()
		
		editor.set_object_and_property(object, name)
		#add_custom_control( editor )
		add_property_editor( name, editor )
		#add_property_editor_for_multiple_properties("", PackedStringArray(["min_","max_"]), editor )
		#add_property_editor_for_multiple_properties("", ["min_","max_"], editor )
		#editor.request_ready()
		#object.property_can_revert
		return true
	else:
		return false

#func _property_can_revert(property: StringName) -> bool:
#
	#return false
#
#func _property_get_revert(property: StringName) -> Variant:
#
	#return 
