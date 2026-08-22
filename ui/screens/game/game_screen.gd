extends Control


@onready var EventPanel = %EventPanel
@onready var EventOptions = %OptionsPanel



func _ready() -> void:
	Events.day_changed.connect( _on_day_changed )
	Events.distance_changed.connect( _on_distance_changed )
	Events.location_changed.connect( _on_location_changed )

	Events.action_started.connect( _on_action_started )
	Events.action_ended.connect( _on_action_ended )

	Events.event_started.connect( _on_event_started )
	Events.event_ended.connect( _on_event_ended )
	
	Events.combat_started.connect( _on_combat_started )
	Events.combat_ended.connect( _on_combat_ended )

	%SpeedControlPanel/%PauseButton.pressed.connect( Game.pause )
	%SpeedControlPanel/%NormalSpeedButton.pressed.connect( func():
		if EventManager.event_active() == false:
			Game.game_speed = Game.GameSpeed.NORMAL
			Game.unpause() )
	%SpeedControlPanel/%FastSpeedButton.pressed.connect( func():
		if EventManager.event_active() == false:
			Game.game_speed = Game.GameSpeed.FAST
			Game.unpause() )
	%SpeedControlPanel/%FasterSpeedButton.pressed.connect( func():
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


func _on_day_changed(day: int):
	%DayLabel.text = "Day %s" % [day]


func _on_distance_changed(distance: float):
	%DistanceLabel.text = "%s km" % [distance]


func _on_location_changed(location: Region):
	%InfoPanel/%LocationLabel.text = "Location: " + location.name.capitalize()


func _on_action_started(_action: Game.Action):
	toggle_travel_actions(false)

	for button in %ActionButtonsContainer.get_children():
		button.hide()
	%ActionButtonsContainer/StoppingButton.show()


func _on_action_ended(_action: Game.Action):
	toggle_travel_actions(true)
	
	for button in %ActionButtonsContainer.get_children():
		var action_name = Game.Action.get(button.name.get_slice("B", 0).to_upper())
		# Check if action_name is valid first, then check if is allowed
		if action_name and Game.allowed_actions.has( action_name ):
			# Shows buttons only if they're allowed
			button.show()
	%ActionButtonsContainer/StoppingButton.hide()
	%ActionStatusContainer.hide()


func _on_event_started(_event: Event):
	toggle_travel_actions(false)


func _on_event_ended(_event: Event):
	toggle_travel_actions(true)


func _on_combat_started():
	%EnemyCharacters.show()
	%ActionButtonsContainer.hide()
	for enemy in CombatManager.enemy_party.get_members():
		var enemy_card = preload("res://ui/components/character_card_enemy.tscn").instantiate()
		enemy_card.set_character(enemy)
		%EnemyCharacters.add_child(enemy_card)


func _on_combat_ended():
	%EnemyCharacters.hide()
	for child in %EnemyCharacters.get_children():
		child.queue_free()
	%ActionButtonsContainer.show()


## Enables/Disabled travel actions.
func toggle_travel_actions(enabled: bool):
	for button in %ActionButtonsContainer.get_children():
		button.disabled = !enabled
	if !enabled:
		%ActionButtonsContainer/StoppingButton.disabled = false
