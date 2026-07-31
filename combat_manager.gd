extends Node


var enemies: Array[CharacterData]



func start(opponents: Array[CharacterData]):
	Game.pause()
	
	enemies = opponents
	_populate()
	
	Events.combat_started.emit()


func end():
	Game.unpause()
	Events.combat_ended.emit()


func _populate():
	for enemy in enemies:
		enemy.apply_stat(CharacterData.Stat.HEALTH, randi_range(-1, -10))
		
		
