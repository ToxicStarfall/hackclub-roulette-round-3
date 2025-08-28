extends Control


@onready var EventPanel = %EventPanel
@onready var EventOptions = %OptionsPanel


func apply_event(event: Event):
	#%EventPanel.apply(event)
	#if event is EncounterEvent:
		#%OptionsPanel.apply(event)
	pass


func clear_event():
	#%EventPanel.clear()
	#%OptionsPanel.clear()
	pass
