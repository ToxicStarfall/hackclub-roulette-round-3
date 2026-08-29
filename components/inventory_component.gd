class_name InventoryComponent
extends Resource


@warning_ignore_start("unused_signal")
signal item_added ( item: StringName )
signal item_removed ( item: StringName )
signal item_transferred ( item: StringName )  ## Emitted when an item is moved from one inventory to another.
signal item_dropped ( item: StringName )  ##
signal item_equipped ( item: StringName )
signal item_unequipped ( item: StringName )
signal item_used ( item: StringName )
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
func add(item_id: StringName, quantity: int = 1, _idx: int = -1):
	#print("add")
	#print(get_item(item_id))
	item_id = item_id.replace(" ", "_")  #
	items.set(item_id, get_item(item_id) + quantity)
	item_added.emit(item_id)
	#print("item added: %s x%s." % [item_id, quantity])
	changed.emit()


func remove(item_id: StringName, quantity: int = 1, _idx: int = -1):	
	item_id = item_id.replace(" ", "_")  #
	items.set(item_id, get_item(item_id) - quantity)
	if get_item(item_id) <= 0:  # Unequip items if quantity is 0.
		unequip(item_id)
	item_removed.emit(item_id)
	changed.emit()
	#print("item removed: %s x%s." % [item_id, quantity])


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
	

## Alias for trasnfer().
func pickup(item: StringName,  inventory: InventoryComponent, quantity: int = 1):
	transfer(item, inventory, quantity)


func transfer(item: StringName,  inventory: InventoryComponent, quantity: int = 1):
	remove(item, quantity)
	inventory.add(item, quantity)
	item_transferred.emit(item)


func transfer_all(_item: StringName,  _inventory: InventoryComponent):
	pass


func drop(item: StringName):
	remove(item)
	item_dropped.emit(item)
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


#
func equip_all():
	for key in slots:
		var slot: InventorySlot = slots[key]
		var equippable_items = slot.slot_filter.find()
		equippable_items = equippable_items.filter( func(item_id): return has(item_id) )  # Filters for owned items.
		
		# TODO - Filter equippable items for highest tier
		if equippable_items.size() > 0:
			slot.item = equippable_items.pick_random()
		#item_equipped.emit(item)
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


func use(item_id: StringName):
	if has(item_id):
		match item_id:
			&"ration":
				Game.player.apply_stat(CharacterData.Stat.HUNGER, 30)
				pass
			&"bandage":
				Game.player.apply_stat(CharacterData.Stat.HEALTH, 10)
				pass
			&"healing_salve":
				Game.player.apply_stat(CharacterData.Stat.HUNGER, 15)
				pass
		remove(item_id)
	pass


func view(item_id: StringName):
	# NOTE - Fixes spaces in item names.
	item_id = item_id.replace(" ", "_")
	item_viewed.emit( Registries.ITEMS.load_entry(item_id) )



# If item is equipped anywhere, returns true.
# TODO - Check if item is equipped in specified slot
func is_equipped(item: StringName, slot = "") -> bool:
	slot.to_lower() #NOTE - this does noething but removes unused param warning.
	for key in slots.keys():
		if slots[key].item == item:
			return true
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


func set_slot_config_from(slot_config_id: String):
	var path: String = "res://data/characters/inventory/slot_configs/" + slot_config_id + "tres"
	if ResourceLoader.exists(path):
		set_slot_config( ResourceLoader.load(path) )


# - - - - GETTERS - - - - #

func get_context_menu_options(item_id: StringName) -> Array:
	var options: Array = ContextMenuOptions.keys()
	item_id.replace(" ", "_")
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
func get_item(item_id: StringName) -> int:
	if items.has(item_id):
		return items.get(item_id)
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
