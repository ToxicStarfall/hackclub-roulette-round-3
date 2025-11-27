class_name PointAttackWeapon
extends RangedWeapon


func _attack():
	var projectile = $ProjectileSpawner.spawn()
	#var size = projectile.get_node("CollisionShape2D").shape.radius / 2
	var attack_point = get_global_mouse_position()
	#projectile.velocity = attack_dir.normalized() * projectile_velocity
	projectile.position = attack_point
	projectile.faction = self.user.faction
	projectile.add_child( $AttackComponent.duplicate() )
	get_parent().get_parent().add_child(projectile)


func _alt_attack():
	pass
