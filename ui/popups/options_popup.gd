extends FloatingPanelContainer


signal option_selected(option: String)



func _ready() -> void:
	pass


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if not Rect2(Vector2(), size).has_point( get_local_mouse_position() ):
			#UI.clear_popups()


#func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int):
	#if mouse_button_index == 1:
		#option_selected.emit( %ItemList.get_item_text(index), item )
	#elif mouse_button_index == 2:
		#UI.clear_popups()


func set_prompt(prompt: String):
	%Prompt.text = prompt


func set_options(options: Array[String]):
	for option in options:
		var button = Button.new()
		button.text = option.capitalize()
		button.pressed.connect( func(): option_selected.emit(option) )
		%OptionsContainer.add_child(button)
