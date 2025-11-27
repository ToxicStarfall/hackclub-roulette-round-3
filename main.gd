extends Node


func _ready() -> void:
	#Game.start_game()
	get_node("%StartMenu/HBoxContainer/VBoxContainer/PlayButton").pressed.connect( _on_play_button_pressed )
	get_node("%StartMenu").show()
	pass


#func start_game():
	#%UI/%StartMenu.hide()
	#EventManager.start_event(EventManager.current_event)


func _on_play_button_pressed() -> void:
	Game.start_game()
	pass
