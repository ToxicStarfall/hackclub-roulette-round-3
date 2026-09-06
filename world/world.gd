extends Node2D


const BACKGROUND_DIR = "res://world/background/environment/"

var sun_tween: Tween



func _ready() -> void:
	Events.location_changed.connect( _on_location_changed )
	pass


func _process(_delta: float) -> void:
	# TODO - improve semi randomized parallax textures
	if %Front.scroll_offset.x > %Front.repeat_size.x - 10:
		var region_name = Game.current_location.name.to_lower()
		var sprite_options = ResourceLoader.list_directory("res://world/background/environment/%s/front" % [region_name])
		if !sprite_options.is_empty():
			var sprite: Texture2D = ResourceLoader.load("res://world/background/environment/%s/front/%s" % [region_name,Array(sprite_options).pick_random()])
			%Front/Sprite2D.texture = sprite
	pass


func _on_location_changed(location: Region):
	apply_region_background( location.name.to_lower() )
	pass


func apply_region_background(region_name: String):
	var region_dir = BACKGROUND_DIR + region_name
	var region_files = ResourceLoader.list_directory(region_dir)

	for parallax_2d in %Parallax.get_children():
		if region_files.size() > parallax_2d.get_index():
			var texture = ResourceLoader.load(region_dir + "/" + region_files.get( parallax_2d.get_index() ))
			parallax_2d.get_node("Sprite2D").texture = texture
	%Front/Sprite2D.texture = null


func activate_parallax():
	%Clouds.autoscroll.x = -5.0  # -10.0
	%Midground.autoscroll.x = -15.0  # -25.0
	%Foreground.autoscroll.x = -40.0  # -50.0
	%Event.autoscroll.x = -100.0  # -100.0
	%Front.autoscroll.x = -80.0  # -100.0
	
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
	#tween.tween_property(%Parallax, "modulate", Color(0.5, 0.333, 0.25, 1.0), 2)
	tween.tween_property(%Parallax, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2)
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
