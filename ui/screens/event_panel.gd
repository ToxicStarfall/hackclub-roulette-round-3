extends PanelContainer


func _ready() -> void:
	EventManager.event_started.connect( _on_event_started )
	EventManager.event_ended.connect( _on_event_ended )
	EventManager.dialogue_changed.connect( _on_dialogue_changed )


func _on_event_started(event: Event2, dialogue_line: DialogueLine):
	self.show()
	%TitleLabel.text = "[b]%s[/b]" % [event.title]
	#%DescriptionLabel.text = "%s" % [event.description]
	%DescriptionLabel.text = "%s" % [dialogue_line.text]


func _on_event_ended(_event):
	clear()


func _on_dialogue_changed(dialogue):
	clear()
	self.show()
	print("dialogue changed")
	#%DescriptionLabel.text = dialogue.description
	#%DescriptionLabel.text = dialogue
	#if EventManager.current_dialogue.options.size() == 0:
		#%DescriptionLabel.text += "
		#[u][i]Click to continue[/i][/u]"


func _on_dialogue_button_pressed() -> void:
	# Only allow "click to cont." when there are no dialogue options.
	#if EventManager.current_dialogue.options.size() == 0:
	if !EventManager.current_dialogue_line.has("responses"):
		#var dialogue_line = await EventManager.current_dialogue.get_next_dialogue_line("")
		#EventManager.dialogue_progressed.emit("")
		pass


#func animate_dialogue(text: String):
	#pass


func clear():
	self.hide()
