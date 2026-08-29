extends Control


var character: CharacterData


func _ready() -> void:
	%InfoButton.pressed.connect( func(): if has_node("CharacterInfo"): $CharacterInfo.show() )
	#%InfoButton.mouse_entered.connect( func(): mouse_default_cursor_shape = CURSOR_POINTING_HAND )
	#%InfoButton.mouse_exited.connect( func(): mouse_default_cursor_shape = CURSOR_ARROW )
	
	#print(has_node("CharacterInfo"))
	if has_node("CharacterInfo") and character:
		$CharacterInfo.linked_character = character
		$CharacterInfo.linked_inventory = character.inventory


func _on_character_stat_changed(_stat):
	update()


func set_character(new_character: CharacterData):
	character = new_character
	character.stat_changed.connect( _on_character_stat_changed )
	%NameLabel.text = character.name
	_ready()
	update()


func update():
	%HungerBar.max_value = character.get("max_hunger")
	%HealthBar.max_value = character.get("max_health")
	%HungerBar.value = character.get("hunger")
	%HealthBar.value = character.get("health")
	%HungerBar/Label.text = "%s / %s" % [snapped(character.get("hunger"), 0.1), snapped(character.get("max_hunger"), 1)]
	%HealthBar/Label.text = "%s / %s" % [snapped(character.get("health"), 0.1), snapped(character.get("max_health"), 1),]
	
	if character.get("health") < character.get("health") * 0.7:
		#%ProfileIcon.texture = load("res://ui/icons/profile_hurt.png")
		%ProfileIcon.texture = load("res://assets/textures/characters/profile_new.svg")
	else:
		#%ProfileIcon.texture = load("res://ui/icons/profile_normal.png")
		%ProfileIcon.texture = load("res://assets/textures/characters/profile_new.svg")
