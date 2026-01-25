class_name Chase
extends State


@export var chase_speed := 75.0
@export var always_chase: bool = false
var a = 0.0


#func enter():
	#print("entered chase")
	#pass


func process_state(delta: float) -> void:
	a += delta
	entity.scale.y = max(1, abs(sin(a * 4) * 0.5) + 1)


func physics_process_state(_delta: float):
	if player:
		var direction := player.global_position - entity.global_position

		var distance = direction.length()
		if !always_chase:
			if distance > entity.chase_radius:
				#transitioned.emit(self, "wander")
				return

		entity.velocity = direction.normalized() * chase_speed

		# Stops a certain distance away from player when close enough.
		#if distance <= enemy.follow_radius:
			#enemy.velocity = Vector2.ZERO
		# At a certain distance, use dash attack at player if not in cooldown.
		if distance <= 300:
			if entity is Enemy:
				if get_parent().has_node("Dash"):
					if get_parent().get_node("Dash").is_ready():  # check required, else infinitely stuck before dash.enter()'s main body
						transitioned.emit(self, "dash")

		entity.move_and_slide()
	else:
		entity.velocity = Vector2.ZERO
