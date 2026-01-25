class_name HitboxComponent
extends Area2D


#signal hit(damage, damage_type)
signal hit(damage)


func _init() -> void:
	area_entered.connect( _on_hitbox_area_entered )
	body_entered.connect( _on_hitbox_body_entered )


func _ready() -> void:
	pass


func _on_hitbox_area_entered(area):
	#print(area, " entered hitbox")
	hit.emit(area.get_damage())


func _on_hitbox_body_entered(body):
	# Physical/Melee/Body damage here.
	#print(body, " entered hitbox")
	if body.faction != get_parent().faction:  # Prevent damaging self
		hit.emit(body.get_damage())
		if body is Projectile:
			#body.queue_free()
			# Projectiles handle hits individaully per body hit.
			body.HealthComp.damage(1)
			pass
