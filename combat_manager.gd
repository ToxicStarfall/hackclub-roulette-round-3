extends Node


@warning_ignore_start("unused_signal")
signal player_turn_started ()
signal player_turn_ended ()
signal player_action_selected (action: Options)
signal enemy_turn_started ()
signal enemy_turn_ended ()
signal combat_finished (player_win: bool)


enum Options { ATTACK, SKIP, ESCAPE }

var is_in_combat: bool = false
var enemy_party = Party.new()
#var enemies: Array[CharacterData]

var loot: Dictionary[StringName, int] = {}


func _ready() -> void:
	player_action_selected.connect( _on_player_action_selected )


#func _setup_enemies():
	#pass


#func start(opponents: Array[CharacterData]):
func start(opponents: CharacterData):
	EventManager.end_event()
	Game.pause()
	is_in_combat = true
	
	enemy_party.member_killed.connect( _on_enemy_party_member_killed )
	#enemy_party.add_members(opponents)
	enemy_party.add_member(opponents)
	
	Events.combat_started.emit()
	player_turn_started.emit()


func end():
	Game.unpause()
	is_in_combat = false
	Events.combat_ended.emit()



func _start_turn_player():
	player_turn_started.emit()
	#_await_action_player()


func _on_player_action_selected(_action: Options):
	_process_turn_player()


func _process_turn_player():
	if enemy_party.is_defeated():
		combat_finished.emit(true)
	else:
		player_turn_ended.emit()
		_start_turn_enemy()
	
	

func _start_turn_enemy():
	enemy_turn_started.emit()
	_await_action_enemy()


func _await_action_enemy():
	# Randomize enemy action here
	
	_process_turn_enemy()


func _process_turn_enemy():
	await get_tree().create_timer(.5).timeout
	var equipped_item_id = enemy_party.get_members()[0].inventory.slots.get(&"primary", "")
	if !equipped_item_id: equipped_item_id = "fists"
	
	var attack_item = Game.player.get_item_comp(equipped_item_id)
	var attack_damage = attack_item.damage
		
	for member in Game.party.get_members():
		member.apply_stat(CharacterData.Stat.HEALTH, -attack_damage)
	Events.audio_requested.emit( AudioManager.find("sounds/punch"), "SFX" )
	
	await get_tree().create_timer(.5).timeout
	
	if Game.party.is_defeated():
		combat_finished.emit(false)
		UI.tween_fade()
		EventManager.start_event("game/death")
	else:
		enemy_turn_ended.emit()
		_start_turn_player()



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
