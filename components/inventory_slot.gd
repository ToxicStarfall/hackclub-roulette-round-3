class_name InventorySlot
extends Resource


@export var icon_hint: Texture2D
var icon: Texture2D
var item: StringName
var quantity: int


@export_group("Configuration")
#@export var min_quantity: int
#@export var max_quantity: int = 1
@export var slot_filter: ItemFilter
