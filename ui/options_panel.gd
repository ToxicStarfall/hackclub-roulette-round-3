extends PanelContainer


signal option_selected

const OptionButtonGroup = preload("res://ui/options/option_button_group.tres")
var options


func _ready() -> void:
	OptionButtonGroup.pressed.connect( _on_option_pressed )
	EventManager.event_started.connect( _on_event_started )
	EventManager.event_ended.connect( _on_event_ended )
	EventManager.event_changed.connect( _on_event_changed )
	EventManager.dialogue_changed.connect( _on_dialogue_changed )


func _on_event_started(event):
	pass


func _on_event_ended():
	clear()


func _on_event_changed(event):
	pass


func _on_dialogue_changed(dialogue):
	clear()
	#if dialogue.has("options"):
	if dialogue.get("options"):
		options = dialogue.options

		for option in dialogue.options:
			#if !option.has("type"):
			if !option.get("type"):
				var new_option = Button.new()
				new_option.button_group = OptionButtonGroup
				new_option.toggle_mode = true
				#new_option.pressed.connect( _on_option_pressed )
				new_option.text = option.name
				#if option.has("tooltip"):
				if option.get("tooltip"):
					new_option.tooltip_text = option.tooltip
				%OptionsContainer.add_child(new_option)
			else:
				print("This options has a type")
				print(option.type)
		self.show()


func clear():
	self.hide()
	options = null
	for child in %OptionsContainer.get_children():
		child.queue_free()


func _on_option_pressed(option_button):
	var option_idx = option_button.get_index()
	var option = options[option_idx]
	for effect in option.effects:
		effect.apply()

	var path = ""
	#if option.has("path"): path = option.path
	if option.get("path"): path = option.path

	EventManager.dialogue_requested.emit(path)
	#option_selected.emit()
