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
	
	OPTIONS_POPUP = preload("res://ui/popups/options_popup.tscn"),
}


var popups: Array[Control]
@onready var ui = get_tree().root.get_node("Main/UI")


func _ready() -> void:
	
	# Initial screen setup
	ui.get_node("SplashScreen").hide()
	ui.get_node("MainMenu").show()
	ui.get_node("GameScreen").hide()
	ui.get_node("PauseMenu").hide()
	
	
	var input_mask = Control.new()
	input_mask.name = "InputCatcher"
	input_mask.set_anchors_preset(Control.PRESET_FULL_RECT)
	input_mask.z_index = 1
	add_child(input_mask)
	
	input_mask.gui_input.connect( _on_input_mask_gui_input )
		


func _on_input_mask_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		clear_popups()



func add_popup(node: Control):
	popups.append(node)
	ui.add_child(node)


func clear_popups():
	for popup in popups:
		if popup:
			popups.erase(popup)
			if !popup is FloatingPanelContainer:
				popup.queue_free()
