extends Control


func _ready() -> void:
	# Initial screen setup
	$SplashScreen.hide()
	%MainMenu.show()
	%GameScreen.hide()
	$PauseMenu.hide()
	pass
