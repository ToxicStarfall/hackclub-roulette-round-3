extends PanelContainer


enum Options { ATTACK, SKIP, ESCAPE }

@onready var loot_tree: InventoryTree = %LootInventoryTree



func _setup():
	#loot_tree.create_item()
	#loot_tree.set_column_expand_ratio(0, 3)
	#loot_tree.items = CombatManager.loot
	loot_tree.inventory = InventoryComponent.from( CombatManager.loot )
	loot_tree.inventory.inventory_mode = InventoryComponent.InventoryMode.LOOT
	pass


func _ready() -> void:
	_setup()
	Events.combat_started.connect( _on_combat_started )
	Events.combat_ended.connect( _on_combat_ended )
	CombatManager.combat_finished.connect( _on_combat_finished )
	pass


func _on_combat_started():
	show()
	populate_options()


func _on_combat_ended():
	hide()


func _on_combat_finished(player_win: bool):
	%OptionsContainer.hide()
	$%CombatResultsPanel.show()
	%ResultLabel.text = "Combat %s" % ["Success" if player_win else "Defeat"]
	loot_tree.update()
	
	
	var tween = create_tween()
	# Success label popout
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(%ResultLabel, "offset_transform_scale", Vector2(5, 5), 1)
	tween.tween_property(%ResultLabel, "offset_transform_scale", Vector2(1.5, 1.5), 3)
	# TODO - Add animated listing of loot items.
	pass


func populate_options():
	for option in Options.keys():
		var button = Button.new()
		button.text = option.capitalize()
		%OptionsContainer.add_child(button)
		button.pressed.connect( _option_selected.bind(button.get_index()) )


func _option_selected(option: int):
	match option:
		Options.ATTACK:
			var equipped_item_id = Game.player.inventory.slots.get(&"primary", "").item
			if !equipped_item_id: equipped_item_id = "fists"
			
			var attack_item = Game.player.get_item_comp(equipped_item_id)
			
			var attack_damage = attack_item.damage
			#if attack_item:
				##attack_damage = Registries.ITEMS.load_entry(attack_item).damage
				#print(attack_item.damage)
				#attack_damage = attack_item.damage
				
			for enemy in CombatManager.enemy_party.get_members():
				enemy.apply_stat(CharacterData.Stat.HEALTH, -attack_damage)
			pass
		Options.SKIP:
			# Add recovery effects
			# Bonuses for defense actions.
			pass
		Options.ESCAPE:
			# Compare against enemy movement efficiency and agility attributes.
			#  +/- 10% per light-weight/over-weight inventory status.
			#  +/- 5% per agility difference for each enemy and player characters.
			#  +/- 1% per movement efficiency difference for each enemy and player characters.
			#  +/- X% for status effects
			var attribute_diff = CombatManager.get_party_attribute_difference(CharacterData.Attribute.AGILITY) * 5
			var efficiency_diff = CombatManager.get_party_efficiency_difference(CharacterData.Efficiency.MOVEMENT)
			var escape_chance = 50 + (attribute_diff + efficiency_diff)
			var escape_reuslt = randf_range(0, 100)
			
			# Escape success
			if escape_reuslt < escape_chance:
				CombatManager.end()
				pass
			# Escape fail
			else:
				pass
	CombatManager._process_turn_player()
	pass
