extends Control


const Scenes = {
	# Characters
	CHARACTER_CARD = preload("res://ui/components/character_card.tscn"),
	CHARACTER_CARD_ENEMY = preload("res://ui/components/character_card_enemy.tscn"),
	# Inventory
	CONTEXT_MENU = preload("res://ui/popups/context_menu.tscn"),
	INVENTORY_SLOT = preload("res://ui/components/inventory/inv_slot.tscn"),
	ITEM_TOOLTIP = preload("res://ui/popups/item_tooltip.tscn"),
	#STATUS_TOOLTIP = preload(""),
	
	#TEXT_POPUP = preload(""),
	OPTIONS_POPUP = preload("res://ui/popups/options_popup.tscn")
	#PLAIN_TEXT_POPUP = preload(""),
}


var popups: Array[Control]
@onready var ui = get_tree().root.get_node("Main/UI")


func _ready() -> void:
	Events.game_started.connect( _on_game_started )
	Events.game_ended.connect( _on_game_ended )
	
	# Initial screen setup
	ui.get_node("SplashScreen").hide()
	ui.get_node("MainMenu").show()
	ui.get_node("GameScreen").hide()
	ui.get_node("PauseMenu").hide()

	#tween.tween_property(Game.World, "modulate", Color(Color.BLACK, 0.9), 3.0)
	#tween.tween_property(Game.UI, "modulate", Color(Color.BLACK, 0.9), 3.0)
	#await tween.finished
	#
	#tween.tween_property(Game.World, "modulate", Color(1,1,1, 0.9), 2.0)
	#tween.tween_property(Game.UI, "modulate", Color(1,1,1, 0.9), 2.0)
	
	
	var input_mask = Control.new()
	input_mask.name = "InputCatcher"
	input_mask.set_anchors_preset(Control.PRESET_FULL_RECT)
	input_mask.z_index = 1
	add_child(input_mask)
	
	input_mask.gui_input.connect( _on_input_mask_gui_input )


func _on_game_started():
	tween_fade()
	pass


func _on_game_ended():
	pass



func _on_input_mask_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		clear_popups()



func tween_fade(enabled: bool = true):
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(Game.World, "modulate", Color(Color.BLACK, 0.9), 2.0)
	tween.tween_property(ui, "modulate", Color(Color.BLACK, 0.9), 2.0)
	#tween.set_parallel(false)
	await tween.finished
	#tween.set_parallel()
	tween = get_tree().create_tween()
	if enabled:
		ui.get_node("%MainMenu").hide()
		ui.get_node("%GameScreen").show()
		ui.get_node("%GameScreen/EventPanelWrapper").top_level = true
	else:
		tween.tween_property(Game.World, "modulate", Color(1,1,1, 1.0), 2.0)
		tween.tween_property(ui, "modulate", Color(1,1,1, 1.0), 2.0)
	#else:
		#ui.get_node("%MainMenu").show()
		#ui.get_node("%GameScreen").show()
		#print("Ads")
		#ui.get_node("%GameScreen/EventPanelWrapper").top_level = true


func add_popup(node: Control):
	popups.append(node)
	ui.add_child(node)


func clear_popups():
	for popup in popups:
		if popup:
			popups.erase(popup)
			if !popup is FloatingPanelContainer:
				popup.queue_free()
