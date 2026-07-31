extends PanelContainer


func _ready() -> void:
	%DevPanel/%SkipDayButton.pressed.connect( func():
		Game.current_hour = Game.HOURS_PER_DAY )
	%DevPanel/%RestartEventButton.pressed.connect( func():
		if EventManager.event_active():
			EventManager.restart_event()
		)
	pass
