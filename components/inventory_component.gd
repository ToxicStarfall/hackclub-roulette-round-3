class_name InventoryComponent
extends Node


#var items: Array[Item] = []
#var items: Array = []
var items: Dictionary = {
	GOLD = 0,
	FOOD = 0,
}

@export var size: int
@export var size_grid: Vector2


func get_item(item: String):
	return int(items.get(item))


func add(item: String, quantity: int, _idx: int = -1):
	items.set(item, int(items.get(item)) + quantity)


func remove(item: String, quantity: int, _idx: int = -1):
	items.set(item, int(items.get(item)) - quantity)


func swap(_idx: int, _idx2: int):
	pass

#func add_grid(item: Item, quantity: int, grid_pos: Vector2i):
	#pass
#
#func remove_grid(item: Item, quantity: int, grid_pos: Vector2i):
	#pass
#
#func swap_grid(grid_pos: Vector2i, grid_pos_2: Vector2i):
	#pass
