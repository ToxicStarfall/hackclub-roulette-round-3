extends PanelContainer


#signal option_selected

const OptionButtonGroup = preload("res://ui/screens/options/option_button_group.tres")
var options


func _ready() -> void:
	OptionButtonGroup.pressed.connect( _on_option_pressed )
	#EventManager.event_started.connect( _on_event_started )
	#EventManager.event_ended.connect( _on_event_ended )
	#EventManager.event_changed.connect( _on_event_changed )
	#EventManager.dialogue_changed.connect( _on_dialogue_changed )


func _on_event_started(_event):
	pass


func _on_event_ended(_event):
	clear()


func _on_event_changed(_event):
	pass


func _on_dialogue_changed(dialogue):
	pass
	clear()
	if dialogue.get("options"):
		options = dialogue.options

		for option in dialogue.options:
			if !option.get("type"):
				var new_option = Button.new()
				new_option.button_group = OptionButtonGroup
				new_option.toggle_mode = true
				new_option.text = option.name
				if option.get("tooltip"):
					new_option.tooltip_text = option.tooltip
				%OptionsContainer.add_child(new_option)
			#else:
				#print("This options has a type")
				#pass
		print(Game.toggles)
		if Game.toggles.gamble:
			var new_option = Button.new()
			new_option.button_group = OptionButtonGroup
			new_option.toggle_mode = true
			new_option.text = "Random"
		self.show()


func clear():
	self.hide()
	options = null
	for child in %OptionsContainer.get_children():
		child.queue_free()


func _on_option_pressed(option_button):
	var option_idx = option_button.get_index()
	var option = options[option_idx]
	var path = ""

	# Gamba option
	if option_button.text == "Random":
		for effect in option.effects:
			if effect:  # Non empty check
				effect.apply()
				if effect.outcome_1 or effect.outcome_2:
					# If there are outcomes specified for effects, ignore default dialogue continue
					return
		#if path != null: # As long as path has not been affected by any effect Outcomes
		if option.get("path"): path = option.path
		EventManager.dialogue_requested.emit(path)
		return

	for effect in option.effects:
		if effect:  # Non empty check
			effect.apply()
			if effect.outcome_1 or effect.outcome_2:
				# If there are outcomes specified for effects, ignore default dialogue continue
				return
	#if path != null: # As long as path has not been affected by any effect Outcomes
	if option.get("path"): path = option.path

	EventManager.dialogue_requested.emit(path)
	#option_selected.emit()
