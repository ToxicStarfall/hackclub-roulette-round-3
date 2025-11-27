class_name EntitySpawner
extends Marker2D


@export var entity_scene: PackedScene


func spawn():
	var entity = entity_scene.instantiate()
	if entity is not Entity:
		push_error("Non-projectile scene assigned to ProjectileSpawner!")
	else:
		return entity
