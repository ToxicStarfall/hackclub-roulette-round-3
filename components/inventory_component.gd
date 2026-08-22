class_name InventoryComponent
extends Resource


@warning_ignore_start("unused_signal")
signal item_added ( item: StringName )
signal item_removed ( item: StringName )
signal item_transferred ( item: StringName )  ## Emitted when an item is moved from one inventory to another.
signal item_equipped ( item: StringName )
signal item_unequipped ( item: StringName )
signal item_viewed ( item: StringName )
#signal changed ()  ## Emitted when an item is used or changes slots.
#signal weight_changed ( weight: float, overweight: bool )  ## Emitted when the total weight of the inventory changes.

enum InventoryMode { NORMAL, LOOT, SHOP, QUEST }
enum ContextMenuOptions { VIEW, INSPECT, USE, EQUIP, UNEQUIP, PICKUP, DROP, SUBMIT, TRANSFER, PURCHASE }


@export var inventory_mode: InventoryMode = InventoryMode.NORMAL

@export var size: int  ## Maximum inventory length.
@export var size_grid: Vector2

#@export var slot_is_storage: bool = false
@export var grid_enabled: bool = false
#@export var weight_enabled

#@export var slots: int = -1

#var items: Array[Item] = []
#@export_custom(Registry.PROPERTY_HINT_CUSTOM, "res://data/registries/items.tres,true,true") var items: Array[StringName]
@export var slots: Dictionary[StringName, InventorySlot]

var items: Dictionary[StringName, int] = {}


## Creates and returns a new inventory resource based on a dictionary of items.
static func from(inventory_items: Dictionary[StringName, int]) -> InventoryComponent:
	var new_inventory = InventoryComponent.new()
	new_inventory.items = inventory_items
	return new_inventory


## Returns true if inventory has at least <quantity> of <item>.
func has(item: StringName, quantity: int = 1, exact: bool = false) -> bool:
	#print("item available: %s x%s. x%s needed. %s" % [item, get_item(item), quantity, get_item(item) >= quantity])
	if exact:
		return get_item(item) == quantity
	else:
		return get_item(item) >= quantity


##
func add(item: StringName, quantity: int, _idx: int = -1):
	items.set(item, get_item(item) + quantity)
	item_added.emit(item)
	#print("item added: %s x%s." % [item, quantity])
	changed.emit()


func remove(item: StringName, quantity: int, _idx: int = -1):
	items.set(item, get_item(item) - quantity)
	item_removed.emit(item)
	changed.emit()
	#print("item removed: %s x%s." % [item, quantity])


func swap(_idx: int, _idx2: int):
	changed.emit()
	pass


## Grid inventories only.
#func add_grid(item: Item, quantity: int, grid_pos: Vector2i):
	#pass

#func remove_grid(item: Item, quantity: int, grid_pos: Vector2i):
	#pass

#func swap_grid(grid_pos: Vector2i, grid_pos_2: Vector2i):
	#pass


func transfer(item: StringName,  inventory: InventoryComponent, quantity: int = 1,):
	remove(item, quantity)
	inventory.add(item, quantity)
	item_transferred.emit(item)


func transfer_all(item: StringName,  inventory: InventoryComponent):
	pass


func drop():
	pass


## Returns the difference between the owned quantity of <item> and <value>.
func difference(item: String, value: int) -> int:
	return abs(get_item(item) - value)


#func filter(filter):
	#pass


func equip(item: StringName):
	var item_data: ItemData = Registries.ITEMS.load_entry(item)
	
	var slot_type = ItemData.SlotType.find_key(item_data.slot_type).to_lower()
	if slots.keys().has( slot_type ):
		slots[ slot_type ].item = item 
		
	#item_equipped.emit(item)
	changed.emit()


func equip_all():
	for key in slots:
		#var slot: InventorySlot = slots[key]
		#var equippable_items = slot.slot_filter.find()
		#slot.item = equippable_items[0]
		##item_equipped.emit(item)
		pass
	changed.emit()


func unequip(item: StringName):
	for key in slots:
		var slot = slots[key]
		if slot.item == item:
			slot.item = ""
	#item_unequipped.emit(item)
	changed.emit()


func unequip_all():
	for key in slots:
		var slot = slots[key]
		slot.item = ""
		#item_unequipped.emit(item)
	changed.emit()


func view(id: StringName):
	# NOTE - Fixes spaces in item names.
	id = id.replace(" ", "_")
	item_viewed.emit( Registries.ITEMS.load_entry(id) )



# If item is equipped, returns true.
func is_equipped(item: StringName) -> bool:
	#return if slots.
	for key in slots.keys():
		if slots[key].item == item:
			return true
		#else:
			#return false
	return false



func _find_slot(_item: StringName):
	pass


#func _on_context_menu_item_selected():
	#pass


# - - - - SETTERS - - - - #

## Applies a slot configuration
func set_slot_config(slot_config: InventorySlotConfig):
	#print(slot_config.slots)
	slots = slot_config.slots.duplicate()
	#slots.assign(slot_config.slots)


# - - - - GETTERS - - - - #

func get_context_menu_options(item_id: StringName) -> Array:
	var options: Array = ContextMenuOptions.keys()
	var item = Registries.ITEMS.load_entry(item_id)
	
	#print(item_id)
	#print(item)
	# NOTE - Erase options if they arent applicable.
	if !item is ConsumableData:
		options.erase("USE")
		
	if !item is ArmorData and !item is WeaponData:
		options.erase("EQUIP")
		options.erase("UNEQUIP")
	elif item is ArmorData or item is WeaponData:
		if is_equipped(item_id):
			options.erase("EQUIP")
		else:
			options.erase("UNEQUIP")
		
	# TODO - Check against inventory type to remove options "PICKUP" and or "DROP"
	# You should not be able to drop loot from a lootable inventory or pickup items from a active character's inventory.

	if !inventory_mode == InventoryMode.NORMAL:
		options.erase("DROP")
	if !inventory_mode == InventoryMode.LOOT:
		#options.erase("TRANSFER")
		options.erase("PICKUP")
	if !inventory_mode == InventoryMode.SHOP:
		options.erase("PURCHASE")
	if !inventory_mode == InventoryMode.QUEST:
		options.erase("SUBMIT")
		
	#match !inventory_mode:
		#InventoryMode.NORMAL:
			#options.erase("DROP")
			#pass
		#InventoryMode.LOOT:
			#options.erase("TRANSFER")
			#options.erase("PICKUP")
			#pass
		#InventoryMode.SHOP, InventoryMode.QUEST:
			#options.erase("SUBMIT")
			#options.erase("PURCHASE")
			#pass
	options.erase("TRANSFER")
	options.erase("INSPECT")
	return options


## Returns the quantiy of the item.
func get_item(item: StringName) -> int:
	if items.has(item):
		return items.get(item)
	else:
		return 0


## Returns an array of all item keys in this inventory.
func get_items() -> Array[StringName]:
	return items.keys()


#func get_tooltip(item: StringName)


## Returns the total weight of all items in this inventory.
func get_total_weight():
	var total_weight := 0.0
	for key in items.keys():
		total_weight += (Registries.ITEMS.load_entry(key).weight * items[key])
	return total_weight


func get_slot_weight():
	pass
	

func get_print() -> String:
	const ITEMS = Registries.ITEMS
	var text: String = "Inventory\n"
	
	for key in items.keys():
		var item = ITEMS.load_entry(key)
		text += "\t%s" % [item.name]
		text += " - "
		text += "%sx\n" % [items.get(key)]
	return text
