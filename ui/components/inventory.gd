extends PanelContainer


var linked_inventory: InventoryComponent: set = _set_linked_inventory

@onready var equipment_tree: Tree = %EquipmentTree
@onready var inventory_tree: Tree = %InventoryTree
@onready var root: TreeItem = inventory_tree.create_item()


func _setup():
	inventory_tree.item_mouse_selected.connect( _on_item_mouse_selected.bind(inventory_tree) )
	inventory_tree.set_column_expand(0, true)
	inventory_tree.set_column_expand(1, true)
	inventory_tree.set_column_expand_ratio(0, 8)
	inventory_tree.set_column_expand_ratio(1, 2)
	#root.set_text(0, "ROOT")
	
	equipment_tree.item_mouse_selected.connect( _on_item_mouse_selected.bind(equipment_tree) )
	equipment_tree.create_item()
	equipment_tree.set_column_expand(0, true)


func _ready():
	_setup()
	linked_inventory = Game.inventory
	linked_inventory.changed.connect( update )
	linked_inventory.item_equipped.connect( update )
	linked_inventory.item_viewed.connect( _on_item_viewed )
	
	%TabBar.tab_changed.connect( func(tab): %TabContainer.current_tab = tab )

	position.x = get_parent().position.x
	#position.y = self.size.y
	


func _on_item_mouse_selected(mouse_position: Vector2, mouse_button_index: int, tree: Tree):
	#if mouse_button_index == 1:
		#var tooltip = UI.Scenes.ITEM_TOOLTIP.instantiate()
		#tooltip.global_position = get_global_mouse_position()
		#tooltip.z_index = 1
		#UI.add_popup(tooltip)
		
	#elif mouse_button_index == 2:
	if mouse_button_index == 2:
		var context_menu = UI.Scenes.CONTEXT_MENU.instantiate()
		context_menu.option_selected.connect( _on_context_menu_option_selected )
		context_menu.global_position = get_global_mouse_position()
		context_menu.z_index = 1
		UI.add_popup(context_menu)
		
		var item_id = tree.get_item_at_position(mouse_position).get_text(0).to_lower()
		var options = linked_inventory.get_context_menu_options( item_id )
		context_menu.item = item_id
		context_menu.set_options( options )


func _on_context_menu_option_selected(option: String, item):
	linked_inventory.call(StringName(option.to_lower()), item)


func _on_item_viewed(item: ItemData):
	var tooltip = UI.Scenes.ITEM_TOOLTIP.instantiate()
	tooltip.global_position = get_global_mouse_position()
	tooltip.z_index = 1
	tooltip.set_item(item)
	UI.add_popup(tooltip)
	pass


func update():
	_clear_inventory()
	_poppulate_inventory()
	_poppulate_slots()
	_poppulate_statuses()


func _clear_inventory():
	for tree_item in root.get_children():
		#root.remove_child(tree_item)
		tree_item.free()
		
	for tree_item in equipment_tree.get_root().get_children():
		#root.remove_child(tree_item)
		tree_item.free()


func _poppulate_inventory():
	var items = Registries.ITEMS.load_all_blocking()
	
	for id in items:
		if linked_inventory.has(id):
			var item = items.get(id)
			var quantity = linked_inventory.get_item( id )
			
			if quantity > 0:
				var tree_item: TreeItem = inventory_tree.create_item(root)
				tree_item.set_text(0, item.name)
				tree_item.set_text(1, str(quantity))
	
	#for key in linked_inventory.slots.keys():
		#var item_id: StringName = linked_inventory.slots[key].item
		#if item_id:
			#var item = items.get( item_id )
			#var tree_item: TreeItem = equipment_tree.create_item(equipment_tree.get_root())
			#tree_item.set_text(0, item.name)


func _poppulate_slots():
	#for slot_node in %CharInvSlots.get_children():
		#%CharInvSlots.remove_child(slot_node)
		#slot_node.queue_free()
	#for slot_id in linked_inventory.slots:
		#var slot = linked_inventory.slots[slot_id]
		#var slot_node: InvSlotNode = preload("res://ui/components/inventory/inv_slot.tscn").instantiate()
		##new_slot.set_icon( linked_inventory.slots[slot].icon_hint )
		#slot_node.set_item( slot.item, slot.icon_hint )
		#%CharInvSlots.add_child( slot_node )
		
	for key in linked_inventory.slots:
		var slot = linked_inventory.slots[key]
		if slot.item:
			var tree_item: TreeItem = equipment_tree.create_item(equipment_tree.get_root())
			var item = Registries.ITEMS.load_entry(slot.item)
			tree_item.set_text(0, item.name)


func _poppulate_statuses():
	pass


# - - - - SETTERS - - - - #

func _set_linked_inventory(inventory: InventoryComponent):
	linked_inventory = inventory
	update()
