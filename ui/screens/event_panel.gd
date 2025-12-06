extends PanelContainer


#@onready DialogueLabel
@onready var EventTitle := %TitleLabel
@onready var DialogueOutput := %DialogueOutput
@onready var DialogueOptions := %DialogueOptions


func _ready() -> void:
	EventManager.event_started.connect( _on_event_started )
	EventManager.event_ended.connect( _on_event_ended )
	EventManager.dialogue_changed.connect( _on_dialogue_changed )


func _on_event_started(event: Event2):
	self.show()
	%TitleLabel.text = "[b]%s[/b]" % [event.title]
	#%DescriptionLabel.text = "%s" % [event.description]
	#%DialogueLabel.text = "%s" % [dialogue_line.text]


func _on_event_ended(_event):
	clear()
	close()


func _on_dialogue_changed(dialogue_line: DialogueLine):
	#print("dialogue changed")
	clear_dialogue_options()
	%DialogueButton.show()

	for concurrent_line in dialogue_line.concurrent_lines:
		dialogue_line.text += "%s" % [concurrent_line.text]

	if dialogue_line.responses.is_empty():
		dialogue_line.text += "[br][br][u][i]Click to continue[/i][/u]"
	else:
		dialogue_line.text += "[br]"

	DialogueOutput.dialogue_line = dialogue_line
	DialogueOutput.type_out()

	await DialogueOutput.finished_typing
	if dialogue_line.responses:
		%DialogueButton.hide()
	for response in dialogue_line.responses:
		var option = Button.new()
		option.text = response.text
		option.pressed.connect( _on_dialogue_option_selected.bind( response.next_id ))
		DialogueOptions.add_child(option)

		await get_tree().create_timer(0.4).timeout


func _on_dialogue_button_pressed() -> void:
	# Skip text animation if currently animating text.
	if DialogueOutput.is_typing:
		DialogueOutput.skip_typing()
	# Skip dialogue options animaition if not already finished
	elif DialogueOptions.get_child_count() < EventManager.current_dialogue_line.responses.size():
		pass
	# Continue dialogue when there are no dialogue options to make.
	elif EventManager.current_dialogue_line.responses.is_empty():
		EventManager.get_next_dialogue_line()


func _on_dialogue_option_selected(next_dialouge_id: String):
	EventManager.get_next_dialogue_line( next_dialouge_id )
	pass


func clear_dialogue_options():
	for dialogue_option in DialogueOptions.get_children():
		DialogueOptions.remove_child(dialogue_option)


func clear():
	%TitleLabel.text = ""
	DialogueOutput.text = ""


func close():
	self.hide()

func open():
	self.show()
