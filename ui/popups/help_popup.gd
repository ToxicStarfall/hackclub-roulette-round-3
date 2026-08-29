extends FloatingPanelContainer


func _ready() -> void:
	%CloseButton.pressed.connect( func():
		queue_free()
		Game.unpause()
	)
