class_name ProjectileSpawner
extends Marker2D


@export var projectile_scene: PackedScene
#@export_file("*.tscn") var projectile_scene = "res://entities/projectiles/"


func spawn():
	var projectile = projectile_scene.instantiate()
	if projectile is not Projectile:
		push_error("Non-projectile scene assigned to ProjectileSpawner!")
	else:
		return projectile
