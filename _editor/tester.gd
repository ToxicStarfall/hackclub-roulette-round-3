extends Node


func _ready() -> void:
	%CharGenSampleButton.pressed.connect( %CharGen._sample )
	pass
