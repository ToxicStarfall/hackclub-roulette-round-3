class_name HealthComponent
extends Node


signal health_damaged
signal health_zero

@export var max_health: int = 1
@onready var health = max_health


func _ready() -> void:
	pass


func apply_damage(damage_comp):
	var amount = damage_comp.value
	# Handle damage calculations
	# Handle damage modifiers and types
	damage(amount)


func heal(amount):
	print(get_parent(), " healed for amount: ", amount)
	health = min(health + amount, max_health)


func damage(amount):
	#print(get_parent(), " damaged for amount: ", amount)
	health = max(health - amount, 0)

	if amount > 0:
		health_damaged.emit(amount)

	if health == 0:
		health_zero.emit()
