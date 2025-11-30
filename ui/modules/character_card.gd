#extends PanelContainer
extends Control


#var character: Character


func update():
	%HungerBar.value = Game.player.stats.get("hunger")
	%HealthBar.value = Game.player.stats.get("health")
	pass


#func create(linked_character: Character):
	#pass
