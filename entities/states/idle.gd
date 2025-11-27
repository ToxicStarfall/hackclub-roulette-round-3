class_name Idle
extends State


@export var min_time: float = 0.0
@export var max_time: float = 0.0

var idle_timer : Timer

# Upon moving to this state, initialize the
# timer with a random duration.
func enter():
	entity.velocity = Vector2.ZERO

	idle_timer = Timer.new()
	idle_timer.wait_time = randi_range(3, 10)
	idle_timer.timeout.connect(on_timeout)
	idle_timer.autostart = true
	add_child(idle_timer)


func on_timeout():
	transitioned.emit(self, "wander")


func _physics_process(_delta: float) -> void:
	if entity is Enemy:
		try_chase()
	pass


# When leaving this state (for any reason), stop timer,
# disconnect signals, and free timer
# Technically, just queue_free() would be required, but
# I like showcasing all of the options
func exit():
	idle_timer.stop()
	idle_timer.timeout.disconnect(on_timeout)
	idle_timer.queue_free()
	idle_timer = null
