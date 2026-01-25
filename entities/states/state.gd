class_name State
extends Node


## This is the entity state

signal transitioned(state: State, new_state_name: String)

@onready var entity: Entity = get_owner()
var player : Player


func _ready():
	player = get_tree().get_first_node_in_group("player")
	#entity.damaged.connect(on_damaged)


# This is called directly when transitioning to this state
# Useful for setting up the state to be used
func enter():
	pass


# When the state is active, this is essentially the _process() function
func process_state(delta: float):
	pass


# When the state is active, this is essentially the _physics_process() function
func physics_process_state(delta: float):
	pass


# Useful for cleaning up the state
# For example, clearing any timers, disconnecting any signals, etc.
func exit():
	pass


## Non FSM-specific methods. These are utility methods that may be used by multiple states.

# Attempts to switch to chase state if it detects the player
func try_chase() -> bool:
	if player:
		if get_distance_to_player() <= entity.detection_radius:
			transitioned.emit(self, "chase")
			return true
	return false


func get_distance_to_player() -> float:
	return player.global_position.distance_to(entity.global_position)


#func on_damaged(attack: Attack):
	#transitioned.emit(self, "stun")
