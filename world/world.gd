extends Node2D


func activate_parallax():
	%Background2.autoscroll.x = -15.0
	%Midground.autoscroll.x = -30.0
	%Foreground2.autoscroll.x = -60.0
	%Foreground.autoscroll.x = -100.0
	pass


func deactivate_parallax():
	for child in %WorldParallax.get_children():
		child.autoscroll = Vector2.ZERO


func show_village():
	var tween = get_tree().create_tween()
	tween.tween_property(%Foreground/Sprite2D2, "modulate", Color(1,1,1,1), 2)

func hide_village():
	var tween = get_tree().create_tween()
	tween.tween_property(%Foreground/Sprite2D2, "modulate", Color(1,1,1,0), 2)

func show_final_village():
	%Foreground/Sprite2D3.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(%Foreground/Sprite2D3, "modulate", Color(1,1,1,1), 2)
