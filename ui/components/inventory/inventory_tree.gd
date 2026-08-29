class_name InventoryTree
extends Tree


#signal item_used
#signal item_pickup



@export var context_menu_scene: PackedScene
@export var tooltip_scene: PackedScene

@export_group("Displayed Columns")
@export var display_item_name: bool = true
@export var display_item_quantity: bool = false
@export var display_item_description: bool = false
@export var display_item_value: bool = false
@export_group("")

var inventory: InventoryComponent: set = _set_inventory
#var items: Dictionary[StringName, int]

@onready var root = create_item()


func _setup():
	item_mouse_selected.connect( _on_item_mouse_selected )
	
	allow_rmb_select = true
	allow_search = true
	hide_folding = true
	hide_root = true

	# Adds additional columns
	[	display_item_quantity,
		display_item_description,
		display_item_value,
	].map( func(column_config): columns += int(column_config))
	
	set_column_expand(0, true)
	#set_column_expand(1, true)
	set_column_expand_ratio(0, 4)
	#set_column_expand_ratio(1, 2)


func _ready():
	_setup()
	#inventory.changed.connect( update )
	#inventory.item_equipped.connect( update )
	#inventory.item_viewed.connect( _on_item_viewed )


func _on_item_mouse_selected(mouse_position: Vector2, mouse_button_index: int):
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
		
		var item_id = self.get_item_at_position(mouse_position).get_text(0).to_lower()
		var options = inventory.get_context_menu_options( item_id )
		context_menu.item = item_id
		context_menu.set_options( options )


func _on_context_menu_option_selected(option: String, item):
	#print(option)
	if option.to_lower() == "pickup":
		# TODO - More advanced inventory to inventory handling
		# Currently inventory has to be hard coded to player's inventory or loop occurs
		inventory.call( StringName(option.to_lower()), item, Game.inventory )
	else:
		inventory.call( StringName(option.to_lower()), item )



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


func _clear_inventory():
	for tree_item in root.get_children():
		tree_item.free()


func _poppulate_inventory():
	var items = Registries.ITEMS.load_all_blocking()
	
	#for id in items.keys():
	for id in inventory.get_items():
		if inventory.has(id):
			var item = items.get(id)
			var quantity = inventory.get_item( id )
			
			if quantity > 0:
				var tree_item: TreeItem = create_item(root)
				tree_item.set_text(0, item.name)
				tree_item.set_text(1, str(quantity))


# - - - - SETTERS - - - - #

func _set_inventory(new_inventory: InventoryComponent):
	#inventory.changed.disconnect( update )
	#inventory.item_equipped.disconnect( update )
	#inventory.item_viewed.disconnect( _on_item_viewed )
	
	inventory = new_inventory
	inventory.changed.connect( update )
	inventory.item_equipped.connect( update )
	inventory.item_viewed.connect( _on_item_viewed )
	update()
