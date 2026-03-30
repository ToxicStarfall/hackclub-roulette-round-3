extends Control


@onready var EventPanel = %EventPanel
@onready var EventOptions = %OptionsPanel



func _ready() -> void:
	Events.location_changed.connect( _on_location_changed )
	Events.event_started.connect( _on_event_started )
	Events.event_ended.connect( _on_event_ended )
	Events.action_started.connect( _on_action_started )
	Events.action_ended.connect( _on_action_ended )

	%TimePanel/%PauseButton.pressed.connect( Game.pause )
	%TimePanel/%NormalSpeedButton.pressed.connect( func():
		if EventManager.event_active() == false:
			Game.game_speed = Game.GameSpeed.NORMAL
			Game.unpause() )
	%TimePanel/%FastSpeedButton.pressed.connect( func():
		if EventManager.event_active() == false:
			Game.game_speed = Game.GameSpeed.FAST
			Game.unpause() )
	%TimePanel/%FasterSpeedButton.pressed.connect( func():
		if EventManager.event_active() == false:
			Game.game_speed = Game.GameSpeed.FASTER
			Game.unpause() )

	%ForagingButton.pressed.connect( Game.action_start.bind( Game.Action.FORAGING ) )
	%HuntingButton.pressed.connect( Game.action_start.bind( Game.Action.HUNTING ) )
	%FishingButton.pressed.connect( Game.action_start.bind( Game.Action.FISHING ) )
	%RestingButton.pressed.connect( Game.action_start.bind( Game.Action.RESTING ) )
	%StoppingButton.pressed.connect( Game.action_end.bind( Game.Action.TRAVELING, true ) )

	$EventPanelWrapper.show()
	%EventPanel.hide()


#func apply_event(event: Event):
	#%EventPanel.apply(event)
	#if event is EncounterEvent:
		#%OptionsPanel.apply(event)
	#pass


#func clear_event():
	#%EventPanel.clear()
	#%OptionsPanel.clear()
	#pass

func _on_location_changed(location: Region):
	%InfoPanel/%LocationLabel.text = "Location: " + location.name.capitalize()


func _on_event_started(_event: Event):
	action_disable_all()


func _on_event_ended(_event: Event):
	action_enable_all()


func _on_action_started(_action: Game.Action):
	action_disable_all()

	for button in %ActionButtonsContainer.get_children():
		button.hide()
	%ActionButtonsContainer/StoppingButton.show()


func _on_action_ended(_action: Game.Action):
	action_enable_all()
	for button in %ActionButtonsContainer.get_children():
		var action_name = Game.Action.get(button.name.get_slice("B", 0).to_upper())
		# Check if action_name is valid first, then check if is allowed
		if action_name and Game.allowed_actions.has( action_name ):
			# Shows buttons only if they're allowed
			button.show()
	%ActionButtonsContainer/StoppingButton.hide()
	%ActionStatusContainer.hide()


func action_enable_all():
	for button in %ActionButtonsContainer.get_children():
		button.disabled = false


func action_disable_all():
	for button in %ActionButtonsContainer.get_children():
		button.disabled = true
	%ActionButtonsContainer/StoppingButton.disabled = false
