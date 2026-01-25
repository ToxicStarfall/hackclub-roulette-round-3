class_name EntitySpawnerZone
#extends EntitySpawner
#extends Polygon2D

@export var entity_scene: PackedScene
@export var entity_scenes: Array[PackedScene]


func spawn():
	var entity = entity_scene.instantiate()
	if entity is not Entity:
		push_error("Non-projectile scene assigned to ProjectileSpawner!")
	else:
		return entity
