#extends PanelContainer
extends Control


#var character: Character


func set_character_name(character_name: String):
	%NameLabel.text = character_name


func update():
	%HungerBar.value = Game.player.stats.get("hunger")
	%HealthBar.value = Game.player.stats.get("health")
	pass


#func create(linked_character: Character):
	#pass
