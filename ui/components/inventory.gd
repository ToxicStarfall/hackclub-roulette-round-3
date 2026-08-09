extends PanelContainer



enum ContextMenuOptions { VIEW, EQIUP, UNEQUIP, DROP }


var linked_inventory: InventoryComponent: set = _set_linked_inventory

@onready var equipment_tree: Tree = %EquipmentTree
@onready var inventory_tree: Tree = %InventoryTree
@onready var root: TreeItem = inventory_tree.create_item()



func _ready():
	linked_inventory = Game.inventory
	Game.inventory.changed.connect( update )
	%TabBar.tab_changed.connect( func(tab): %TabContainer.current_tab = tab )

	position.x = get_parent().position.x
	#position.y = self.size.y
	
	inventory_tree.set_column_expand(0, true)
	inventory_tree.set_column_expand(1, true)
	inventory_tree.set_column_expand_ratio(0, 8)
	inventory_tree.set_column_expand_ratio(1, 2)
	
	equipment_tree.item_mouse_selected.connect( _on_item_mouse_selected.bind(equipment_tree) )
	equipment_tree.create_item()
	equipment_tree.set_column_expand(0, true)
	


func update():
	_clear_inventory()
	_poppulate_inventory()
	_poppulate_slots()
	_poppulate_statuses()


func get_options(item: StringName):
	pass


func _clear_inventory():
	for tree_item in root.get_children():
		root.remove_child(tree_item)


func _poppulate_inventory():
	var items = Registries.ITEMS.load_all_blocking()
	
	for id in items:
		if Game.inventory.has(id):
			var item = items.get(id)
			var quantity = Game.inventory.get_item( id )
			
			if quantity > 0:
				var tree_item: TreeItem = inventory_tree.create_item(root)
				tree_item.set_text(0, item.name)
				tree_item.set_text(1, str(quantity))


func _poppulate_slots():
	for slot_node in %CharInvSlots.get_children():
		%CharInvSlots.remove_child(slot_node)
		slot_node.queue_free()
	for slot_id in linked_inventory.slots:
		var slot = linked_inventory.slots[slot_id]
		var slot_node: InvSlotNode = preload("res://ui/components/inventory/inv_slot.tscn").instantiate()
		#new_slot.set_icon( linked_inventory.slots[slot].icon_hint )
		slot_node.set_item( slot.item, slot.icon_hint )
		%CharInvSlots.add_child( slot_node )
	pass


func _poppulate_statuses():
	pass


# - - - - SETTERS - - - - #

func _set_linked_inventory(inventory: InventoryComponent):
	linked_inventory = inventory
	update()
