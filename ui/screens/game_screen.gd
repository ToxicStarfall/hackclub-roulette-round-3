extends Control


@onready var EventPanel = %EventPanel
@onready var EventOptions = %OptionsPanel



func _ready() -> void:
	%TimePanel/%PauseButton.pressed.connect( func():
		Game.pause() )
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

	%DevPanel/%SkipDayButton.pressed.connect( func():
		Game.current_hour = Game.HOURS_PER_DAY )
	%DevPanel/%RestartEventButton.pressed.connect( func():
		if EventManager.event_active():
			EventManager.restart_event()
		)
	pass



#func apply_event(event: Event):
	#%EventPanel.apply(event)
	#if event is EncounterEvent:
		#%OptionsPanel.apply(event)
	#pass


#func clear_event():
	#%EventPanel.clear()
	#%OptionsPanel.clear()
	#pass
