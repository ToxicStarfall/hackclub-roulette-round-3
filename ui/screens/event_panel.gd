extends PanelContainer


#@onready DialogueLabel
@onready var EventTitle := %TitleLabel
@onready var DialogueOutput := %DialogueOutput
@onready var DialogueOptions := %DialogueOptions

var awaiting_input := false  ## Whether dialogue is waiting for text input before progressing.


func _ready() -> void:
	EventManager.event_started.connect( _on_event_started )
	EventManager.event_ended.connect( _on_event_ended )
	EventManager.input_requested.connect( _on_input_requested )
	EventManager.dialogue_changed.connect( _on_dialogue_changed )
	%DialogueInput.text_submitted.connect( _on_input_submitted )


func _on_event_started(event: Event2):
	self.show()
	%TitleLabel.text = "[b]%s[/b]" % [event.title]
	#%DescriptionLabel.text = "%s" % [event.description]
	#%DialogueLabel.text = "%s" % [dialogue_line.text]


func _on_event_ended(_event):
	clear()
	close()


## Shows text input area to enter a response.
func _on_input_requested(prompt: String, _save_id: String, default: String = ""):
	%DialogueInput.show()
	awaiting_input = true
	%DialogueInput.placeholder_text = prompt
	EventManager.store("input_default", default)


func _on_input_submitted(_new_text: String):
	%DialogueInput.hide()
	awaiting_input = false
	var input_result: String = %DialogueInput.text
	if input_result.is_empty():
		input_result = EventManager.retrieve("input_default")
	EventManager.store("input_result", input_result)
	EventManager.get_next_dialogue_line()


func _on_dialogue_changed(dialogue_line: DialogueLine):
	clear_dialogue_options()
	%DialogueButton.show()

	if dialogue_line.responses.is_empty() and !awaiting_input:
		dialogue_line.text += "[br][br][u][i]Click to continue[/i][/u]"
	else:
		# Add spacing between dialogue and input area or dialogue options.
		dialogue_line.text += "[br][br][br]"

	DialogueOutput.dialogue_line = dialogue_line
	DialogueOutput.type_out()

	await DialogueOutput.finished_typing

	#if awaiting_input:
		#$%DialogueInput.show()

	# Add dialogue response options if available.
	for response in dialogue_line.responses:
		var option = Button.new()
		option.text = response.text
		option.pressed.connect( _on_dialogue_option_selected.bind( response.next_id ))
		DialogueOptions.add_child(option)

		if %DialogueButton.visible == false:
			continue
		else:
			await get_tree().create_timer(0.4).timeout
	# Hide skip button if there are response options or when awaiting dialogue input.
	if dialogue_line.responses or awaiting_input:
		%DialogueButton.hide()


func _on_dialogue_button_pressed() -> void:
	# Skip text animation if currently animating text.
	if DialogueOutput.is_typing:
		DialogueOutput.skip_typing()
	# Skip dialogue options animaition if not already finished
	elif DialogueOptions.get_child_count() < EventManager.current_dialogue_line.responses.size():
		%DialogueButton.hide()
	# Continue dialogue when there are no response options to make.
	elif EventManager.current_dialogue_line.responses.is_empty():
		EventManager.get_next_dialogue_line()


func _on_dialogue_option_selected(next_dialouge_id: String):
	EventManager.get_next_dialogue_line( next_dialouge_id )


## Clears and hides text input area.
func clear_dialogue_input():
	%DialogueInput.placeholder_text = ""
	%DialogueInput.text = ""
	%DialogueInput.hide()


## Clears dialogue options.
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
