class_name InventoryComponent
extends Resource


@warning_ignore_start("unused_signal")
signal item_added ( item: StringName )
signal item_removed ( item: StringName )
signal item_equipped ( item: StringName )
signal item_unequipped ( item: StringName )
#signal changed ()  ## Emitted when an item is used or changes slots.
#signal weight_changed ( weight: float, overweight: bool )  ## Emitted when the total weight of the inventory changes.


@export var size: int  ## Maximum inventory length.
@export var size_grid: Vector2

#@export var slot_is_storage: bool = false
@export var grid_enabled: bool = false
#@export var weight_enabled

#@export var slots: int = -1

#var a: InventorySlot
#var items: Array[Item] = []
#@export_custom(Registry.PROPERTY_HINT_CUSTOM, "res://data/registries/items.tres,true,true") var items: Array[StringName]
@export var slots: Dictionary[StringName, InventorySlot]

var items: Dictionary[StringName, int] = {}



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
	#print("item removed: %s x%s." % [item, quantity])
	changed.emit()


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
	

## Returns the difference between the owned quantity of <item> and <value>.
func difference(item: String, value: int) -> int:
	return abs(get_item(item) - value)


#func filter(filter):
	#pass


func equip_item(item: StringName):
	var item_data: ItemData = Registries.ITEMS.load_entry(item)
	#print(slots["body"].slot_filter.find())
	#print(item_data.slot_type.to_lower())
	#if slots.keys().has( item_data.slot_type.to_lower() ):
	#if slots.keys().filter( func(key): key ==  )#.has( item_data.slot_type.to_lower() ):
		#pass
	item_equipped.emit(item)


func equip_all():
	for key in slots:
		var slot: InventorySlot = slots[key]
		var equippable_items = slot.slot_filter.find()
		slot.item = equippable_items[0]
		#item_equipped.emit(item)
	pass


func unequip_item(item: StringName):
	item_unequipped.emit(item)


func _find_slot(item: StringName):
	pass


# - - - - SETTERS - - - - #

## Applies a slot configuration
func set_slot_config(slot_config: InventorySlotConfig):
	#print(slot_config.slots)
	slots = slot_config.slots
	#slots.assign(slot_config.slots)


# - - - - GETTERS - - - - #

## Returns the quantiy of the item.
func get_item(item: StringName) -> int:
	if items.has(item):
		return items.get(item)
	else:
		return 0


## Returns an array of all item keys in this inventory.
func get_items() -> Array[StringName]:
	return items.keys()


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
