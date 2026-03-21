extends Control



func _ready() -> void:
	%PlayButton.pressed.connect( _on_play_button_pressed )


func _on_play_button_pressed() -> void:
	%MainMenu.hide()
	Events.game_started.emit()
