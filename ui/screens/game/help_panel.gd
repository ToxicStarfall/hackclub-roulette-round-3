extends PanelContainer


func _ready() -> void:
	%HelpButton.pressed.connect( func():
		UI.add_popup(UI.Scenes.HELP_POPUP.instantiate())
		Game.pause()
	)
