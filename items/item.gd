class_name Item
extends Node2D
#extends Area2D
#extends Resource


@warning_ignore_start("unused_signal")
signal item_used
signal item_equipped

@export var icon: Texture2D = preload("res://icon.svg")
@export var title: String = ""
@export_multiline var description: String = ""

var dropped: bool = true

var user: Entity


func _ready() -> void:
	pass
