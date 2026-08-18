@tool
extends EditorProperty



func _ready() -> void:
	#print("ready")
	set_bottom_editor($HBoxContainer)
	
	#%MinSlider.value_changed.connect( func(value):
		##print(value)
		#emit_changed("min_", value)
		##get_edited_object().min_ = value
		#)
	#%MaxSlider.value_changed.connect( func(value): emit_changed("max_", value) )
	
	%MinSlider.value_changed.connect( _on_slider_value_changed.bind(%MinSlider) )
	%MaxSlider.value_changed.connect( _on_slider_value_changed.bind(%MaxSlider) )
	
	#set_object_and_property( get_edited_object(), "min_")
	#set_object_and_property( get_edited_object(), "max_")
	property_can_revert_changed.connect( _on_property_can_revert_changed )
	pass


func _on_slider_value_changed(value, slider):
	#print("slider change")
	var obj = get_edited_object().get( get_edited_property() )
	#print(get_edited_object())
	#print(get_edited_property())
	#print(obj)
	
	var field = StringName(slider.label.to_lower() + "_")
	if obj:
		#obj.min_ = %MinSlider.value
		#obj.max_ = %MaxSlider.value
		obj.set(field, slider.value)
	else:
		obj = NumberRange.new(%MinSlider.value, %MaxSlider.value)
		
	#print("")
	#emit_changed( get_edited_property(), NumberRange.new(%MinSlider.value, %MaxSlider.value))
	emit_changed( get_edited_property(), obj, )


func _update_property() -> void:
	#print("update")
	var obj = get_edited_object().get( get_edited_property() )
	#print(get_edited_object())
	#print(get_edited_property())
	#print(obj)
	
	if obj:
		%MinSlider.value = obj.min_
		%MaxSlider.value = obj.max_
	
	#print("")


func _on_property_can_revert_changed(property: StringName, can_revert: bool):
	print(property, can_revert)
	var obj = get_edited_object().get( get_edited_property() )
	print(obj)
	if !can_revert:
		pass
	

func _property_can_revert(property: StringName) -> bool:
	print("akjsnd")
	return false
func _property_get_revert(property: StringName) -> Variant:
	print("akjsnd")

	return 
