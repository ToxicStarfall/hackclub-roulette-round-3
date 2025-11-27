class_name Charge
extends State


@export var targeting_time: float = 1.0
@export var charge_delay: float = 1.0
@export var charge_velocity: float = 200.0
@export var ignore_cooldown: bool = false
@export var charge_cooldown: float = 3.0
@export var recovery_time: float = 1.0

var attacking: bool = false
#var attack_indincatorr = Line2D.new()
var dash_ready: bool = true
var origin


func enter():
	dash_ready = false
	await get_tree().create_timer(targeting_time).timeout # Attack targeting time

	origin = entity.position
	var dir =  player.position - entity.position
	entity.velocity = dir.normalized() * 400

	await get_tree().create_timer(charge_delay).timeout # Attack init delay
	attacking = true

	await get_tree().create_timer(charge_cooldown).timeout
	dash_ready = true


func physics_process_state(delta):
	if attacking:
		# Stop when certain distance reached
		#if (origin - entity.position).length() >= dash_distance:
			#attacking = false
			#await get_tree().create_timer(RECOVERY_TIME).timeout  # Small stun after attacking
			#transitioned.emit(self, "chase")

		#entity.move_and_slide()
		var collision = entity.move_and_collide(entity.velocity * delta)
		if collision:
			await get_tree().create_timer(1.5).timeout
			transitioned.emit(self, "chase") # crate stun

	#else:
		# While attack not initialized, move attack_indincator to this entity's target


func is_ready():
	return dash_ready
