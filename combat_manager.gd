extends Node


@warning_ignore_start("unused_signal")
signal player_turn_started ()
signal player_turn_ended ()
signal enemy_turn_started ()
signal enemy_turn_ended ()
signal combat_finished (player_win: bool)


enum Options { ATTACK, SKIP, ESCAPE }

var is_in_combat: bool = false
var enemy_party = Party.new()
#var enemies: Array[CharacterData]

var loot: Dictionary[StringName, int] = {}



func _setup_enemies():
	pass


#func start(opponents: Array[CharacterData]):
func start(opponents: CharacterData):
	EventManager.end_event()
	Game.pause()
	is_in_combat = true
	
	enemy_party.member_killed.connect( _on_enemy_party_member_killed )
	#enemy_party.add_members(opponents)
	enemy_party.add_member(opponents)
	
	player_turn_started.emit()
	#_process_turn_player()
	#_process_turn_enemy()
	
	Events.combat_started.emit()


func end():
	Game.unpause()
	is_in_combat = false
	Events.combat_ended.emit()


#func _populate():
	#pass


func _process_turn_player():
	if enemy_party.is_defeated():
		combat_finished.emit(true)
		print(loot)
	else:
		pass
	
	enemy_turn_started.emit()
	_process_turn_enemy()


func _process_turn_enemy():
	var equipped_item_id = enemy_party.get_members()[0].inventory.slots.get(&"primary", "")
	#print(equipped_item_id)
	if !equipped_item_id: equipped_item_id = "fists"
	
	var attack_item = Game.player.get_item_comp(equipped_item_id)
	var attack_damage = attack_item.damage
	#print(attack_damage)
		
	for member in Game.party.get_members():
		member.apply_stat(CharacterData.Stat.HEALTH, -attack_damage)
	
	if Game.party.is_defeated():
		combat_finished.emit(false)
		#print(Game.inventory.get_print())
		UI.tween_fade()
		EventManager.start_event("game/death")
		pass
	
	await get_tree().create_timer(1.0).timeout
	player_turn_started.emit()
	#_process_turn_pl()


func _on_enemy_party_member_killed(enemy: CharacterData):
	#print(enemy.inventory.get_items())
	for item_id in enemy.inventory.get_items():
		if Registries.ITEMS.filter(&"tags", func(i): return !i.has(ItemData.Tags.BODY_PART) ).has(item_id):
			
			if loot.has(item_id):
				loot.set(item_id, loot.get(item_id) + enemy.inventory.get_item(item_id))
			else:
				loot.set(item_id, 0 + enemy.inventory.get_item(item_id))


#func _on_item_dropped(item_id):
	##loot.add
	#pass


# - - - - SETTERS & GETTERS - - - - #

## Returns the difference in the total value of the attribute type of the player and enemy parties.
func get_party_attribute_difference(attribute: CharacterData.Attribute):
	var diff = Game.party.get_attribute_total(attribute) - CombatManager.enemy_party.get_attribute_total(attribute)
	return diff


## Returns the difference in the total value of the efficiency type of the player and enemy parties.
func get_party_efficiency_difference(efficiency: CharacterData.Efficiency):
	var diff = Game.party.get_efficiency_total(efficiency) - CombatManager.enemy_party.get_efficiency_total(efficiency)
	return diff
