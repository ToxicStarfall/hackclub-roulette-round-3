class_name Enemy  #TODO Rename to HostileEntity
extends Entity


@export var chase_radius: float = 300.0
@export var detection_radius: float = 200.0
@export var follow_radius: float = 50.0


#func _ready() -> void:
	#pass


func setup():
	super()
	add_to_group("enemies")


# Override
#func kill():
	#print(self, " killed.")
	#$Sprite2D.hide()
	#$HitboxComponent.queue_free()
	#$CollisionShape2D.queue_free()
	#self.velocity = Vector2.ZERO

	#if self is Enemy:
		#get_parent().score += 5
	#if self is Player: get_parent().game_loss()
	#else:
		#await $"SparksParticles".finished
	#queue_free()
