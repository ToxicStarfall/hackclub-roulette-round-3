class_name InventoryComponent
extends Node


@warning_ignore_start("unused_signal")
signal item_added ( item: String )
signal item_removed ( item: String )
signal changed
@warning_ignore_restore("unused_signal")

#var items: Array[Item] = []
#var items: Array = []

# Items
var items: Dictionary = {
	GOLD = 0,
	FOOD = 0,
	MEDICINE = 0,
	#CLOTH = 0,
	#ROPE = 0,
}

@export var size: int
@export var size_grid: Vector2


## Returns the quantiy of the item
func get_item(item: String) -> int:
	return int(items.get(item))

# Returns an array of all item keys
#static func get_items() -> Array:
	#return items.keys()


## Returns the difference between the owned quantity of <item> and the <value>.
func difference(item: String, value: int) -> int:
	return abs(get_item(item) - value)


## Returns true if inventory has at least <quantity> of <item>.
func has(item: String, quantity: int = 1) -> bool:
	print("item available: %s x%s. x%s needed. %s" % [item, get_item(item), quantity, get_item(item) >= quantity])
	return get_item(item) >= quantity


func add(item: String, quantity: int, _idx: int = -1):
	items.set(item, get_item(item) + quantity)
	item_added.emit(item)
	print("item added: %s x%s." % [item, quantity])
	changed.emit()


func remove(item: String, quantity: int, _idx: int = -1):
	items.set(item, get_item(item) - quantity)
	item_removed.emit(item)
	print("item removed: %s x%s." % [item, quantity])
	changed.emit()


func swap(_idx: int, _idx2: int):
	changed.emit()


#func add_grid(item: Item, quantity: int, grid_pos: Vector2i):
	#pass
#
#func remove_grid(item: Item, quantity: int, grid_pos: Vector2i):
	#pass
#
#func swap_grid(grid_pos: Vector2i, grid_pos_2: Vector2i):
	#pass
