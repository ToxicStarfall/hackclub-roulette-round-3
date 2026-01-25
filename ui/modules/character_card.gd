#extends PanelContainer
extends Control


#var character: Character


func set_character_name(character_name: String):
	%NameLabel.text = character_name


func update():
	%HungerBar.value = Game.player.stats.get("hunger")
	%HealthBar.value = Game.player.stats.get("health")
	if Game.player.stats.get("health") < Game.player.stats.get("health") * 0.7:
		%ProfileIcon.texture = load("res://ui/icons/profile_hurt.png")
	else: %ProfileIcon.texture = load("res://ui/icons/profile_normal.png")
	pass


#func create(linked_character: Character):
	#pass
