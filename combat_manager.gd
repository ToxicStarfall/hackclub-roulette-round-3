extends Node


var enemies: Array[Character]


func initiate(opponents: Array[Character]):
	self.enemies = opponents
	_populate()
	pass


func _populate():
	for enemy in enemies:
		var enemy_card = preload("res://ui/modules/character_card_enemy.tscn").instantiate()
		enemy_card.set_character(enemy)
	
	await get_tree().create_timer(1.0).timeout
	for enemy in enemies:
		enemy.apply_stat(Character.Stat.HEALTH, randi_range(0, -10))
		
		
