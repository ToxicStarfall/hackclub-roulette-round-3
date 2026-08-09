extends Control


var character: CharacterData


func _ready() -> void:
	if has_node("CharacterInventory") and character:
		$CharacterInventory.linked_inventory = character.inventory


func _on_character_stat_changed():
	update()


func set_character(new_character: CharacterData):
	character = new_character
	character.stat_changed.connect( _on_character_stat_changed )
	%NameLabel.text = character.name
	update()


func update():
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
