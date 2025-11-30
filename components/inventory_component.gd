class_name InventoryComponent
extends Node


#var items: Array[Item] = []
var items: Dictionary = {}

@export var size: int
@export var size_grid: Vector2


func add(item: Item, quantity: int, idx: int = -1):
	pass

func remove(item: Item, quantity: int, idx: int = -1):
	pass

func swap(idx: int, idx2: int):
	pass

#func add_grid(item: Item, quantity: int, grid_pos: Vector2i):
	#pass
#
#func remove_grid(item: Item, quantity: int, grid_pos: Vector2i):
	#pass
#
#func swap_grid(grid_pos: Vector2i, grid_pos_2: Vector2i):
	#pass
