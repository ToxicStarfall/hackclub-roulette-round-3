extends Node


@warning_ignore_start("unused_signal")
signal player_turn_started ()
signal enemy_turn_started ()
signal combat_finished (player_win: bool)


enum Options { ATTACK, SKIP, ESCAPE }

var enemy_party = Party.new()
#var enemies: Array[CharacterData]

var loot: Dictionary[StringName, int] = {}



func start(opponents: Array[CharacterData]):
	Game.pause()
	
	enemy_party.member_killed.connect( _on_enemy_party_member_killed )
	enemy_party.add_members(opponents)
	#_populate()
	_process_turn_player()
	
	Events.combat_started.emit()


func end():
	Game.unpause()
	Events.combat_ended.emit()


#func _populate():
	#pass


func _process_turn_player():
	if enemy_party.is_defeated():
		combat_finished.emit(true)
		print(loot)
	else:
		pass
	pass


func _process_turn_enemy():
	if Game.party.is_defeated():
		combat_finished.emit(false)
		pass


func _on_enemy_party_member_killed(enemy: CharacterData):
	for item_id in enemy.inventory.get_items():
		if loot.has(item_id):
			loot.set(item_id, loot.get(item_id) + enemy.inventory.get_item(item_id))
		else:
			loot.set(item_id, 0 + enemy.inventory.get_item(item_id))


 
# - - - - SETTERS & GETTERS - - - - #

## Returns the difference in the total value of the attribute type of the player and enemy parties.
func get_party_attribute_difference(attribute: CharacterData.Attribute):
	var diff = Game.party.get_attribute_total(attribute) - CombatManager.enemy_party.get_attribute_total(attribute)
	return diff


## Returns the difference in the total value of the efficiency type of the player and enemy parties.
func get_party_efficiency_difference(efficiency: CharacterData.Efficiency):
	var diff = Game.party.get_efficiency_total(efficiency) - CombatManager.enemy_party.get_efficiency_total(efficiency)
	return diff
