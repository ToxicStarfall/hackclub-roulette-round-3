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
func get_item(item: String):
	return int(items.get(item))

# Returns an array of all item keys
#static func get_items() -> Array:
	#return items.keys()


func add(item: String, quantity: int, _idx: int = -1):
	items.set(item, quantity)
	item_added.emit(item)
	#changed.emit()


func remove(item: String, quantity: int, _idx: int = -1):
	items.set(item, items.get(item) - quantity)
	item_removed.emit(item)
	#changed.emit()


func swap(_idx: int, _idx2: int):
	changed.emit()
	pass

#func add_grid(item: Item, quantity: int, grid_pos: Vector2i):
	#pass
#
#func remove_grid(item: Item, quantity: int, grid_pos: Vector2i):
	#pass
#
#func swap_grid(grid_pos: Vector2i, grid_pos_2: Vector2i):
	#pass
