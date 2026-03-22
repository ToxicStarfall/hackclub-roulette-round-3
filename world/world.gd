extends Node2D


var sun_tween: Tween


func _ready() -> void:
	pass


func activate_parallax():
	%Background2.autoscroll.x = -15.0
	%Midground.autoscroll.x = -30.0
	%Foreground2.autoscroll.x = -60.0
	%Foreground.autoscroll.x = -100.0
	if sun_tween: if sun_tween.is_valid(): sun_tween.play()


func deactivate_parallax():
	for child in %Parallax.get_children():
		child.autoscroll = Vector2.ZERO
	if sun_tween: sun_tween.pause()


func sunset():
	var tween = get_tree().create_tween()
	sun_tween = tween
	tween.tween_property(%Parallax, "modulate", Color(0.5, 0.25, 0.25, 1.0), 30)
	await tween.finished

func sunrise():
	var tween = get_tree().create_tween()
	sun_tween = tween
	tween.tween_property(%Parallax, "modulate", Color(1.0, 1.0, 1.0, 1.0), 30)
	await tween.finished


func light_to_dark():
	var tween = get_tree().create_tween()
	tween.tween_property(%Parallax, "modulate", Color(0.0, 0.0, 0.0, 1.0), 2)
	await tween.finished

func dark_to_light():
	var tween = get_tree().create_tween()
	tween.tween_property(%Parallax, "modulate", Color(0.5, 0.333, 0.25, 1.0), 2)
	await tween.finished


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
