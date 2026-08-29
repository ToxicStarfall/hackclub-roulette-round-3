extends Node


const SAVE_PATH = "user://save.cfg"

var current_save: ConfigFile = ConfigFile.new()


func save_file():
	current_save.set_value("", "game_speed", Game.game_speed)
	current_save.set_value("", "current_day", Game.current_day)
	current_save.set_value("", "current_hours", Game.current_day)
	current_save.set_value("", "current_ticks", Game.current_day)
	current_save.set_value("", "location", Game.Location)
	current_save.set_value("", "distance_travled", Game.distance_travled)
	
	current_save.set_value("", "party", Game.party)
	current_save.set_value("", "player", Game.player)
	current_save.set_value("", "inventory", Game.inventory)

	#current_save.set_value("", "current_event", EventManager.current_event.id)

	current_save.save(SAVE_PATH)


func load_file():
	if current_save.load(SAVE_PATH) == Error.OK:
		Game.set("game_speed", current_save.get_value("", "game_speed"))
		Game.set("current_day", current_save.get_value("", "current_day"))
		Game.set("current_hours", current_save.get_value("", "current_hours"))
		Game.set("current_ticks", current_save.get_value("", "current_ticks"))
		Game.set("location", current_save.get_value("", "location"))
		Game.set("distance_travled", current_save.get_value("", "distance_travled"))
		
		Game.set("party", current_save.get_value("", "party"))
		Game.set("player", current_save.get_value("", "player"))
		Game.set("inventory", current_save.get_value("", "inventory"))

		#EventManager.start_event( current_save.get_value("", "current_event") )


func reset():
	current_save.clear()
	save_file()
	#current_save.save(SAVE_PATH)
	load_file()
	Events.game_reset.emit()
	pass
