class_name Projectile
extends Entity


#@export var a = ""


func _ready() -> void:
	super()
	#self.body_entered.connect( _on_body_entered )


func _physics_process(_delta: float) -> void:
	move_and_slide()


#func _on_body_entered(body):
	#var damage = body.get_damage().projectile_damage
	#HealthComp.apply_damage(damage)


# This does not run.
# Projectiles are detected by other entities which will manually damage the projectile.
#func _on_hitbox_hit(damage):
	#if damageable:
		#HealthComp.apply_damage(damage)
		##kill()
	#else: print(self, " is immune.")


# Projectiles ignore health damage effects
func _on_health_damaged(_amount):
	pass

# Projectiles ignore all other death effects
func kill():
	queue_free()
