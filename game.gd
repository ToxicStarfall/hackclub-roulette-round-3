extends Node

enum Items {
	GOLD,
	MEDICINE,
	RATIONS,
	WATER,
	WEAPONS,
}

const TOTAL_CYCLES = 10  # 1 cycle = day/night.
const TICKS_PER_CYCLE = 24.0  # 1 tick = 1 second.
const SECONDS_PER_TICK = 3.0 #5.0  #

const EVENT_CHANCE_PER_TICK = 0.30 #0.10  # chance that a event occurs.
const NOTABLE_EVENT_CHANCE = 0.25  # chance for a important event.

var paused: bool = true
var current_cycle = 0
var current_tick = 0
var current_time = 0.0
var elapsed_time = 0.0

var speed_mod = 1.0

var characters = []
var inventory = {
	"gold": 0,
	"medicine": 0,
	"rations": 0,
	"water": 0,
}
var toggles = {
	gamble = false
}


var UI: Control


func _ready() -> void:
	EventManager.event_started.connect( _on_event_started )
	EventManager.event_ended.connect( _on_event_ended )


func _physics_process(delta: float) -> void:
	if !paused:
		get_tree().root.get_node("Main/%WorldParallax/Parallax2D").autoscroll = Vector2(-100,0)
		elapsed_time = snapped(elapsed_time + delta, 0.001)
		current_time = snapped(current_time + delta, 0.01)
		if current_time >= SECONDS_PER_TICK:
			current_tick += 1
			current_time = 0.0  # reset tick timer

			#if current_tick % 1 == 0:
			if current_tick % 4 == 0:
				if randf() <= EVENT_CHANCE_PER_TICK:
					#paused = true
					#if randf() <= notable_event_chance:
						#EventManager.start_event(load("res://events/event_1.tres"))
					#else:
						#EventManager.start_event(load("res://events/event_1.tres"))
					EventManager.start_event(Event.new())
					print("new event start rand")

			UI.get_node("%TravelProgress").value = current_tick
	else:
		get_tree().root.get_node("Main/%WorldParallax/Parallax2D").autoscroll = Vector2.ZERO

	if current_tick >= TICKS_PER_CYCLE:
		current_cycle += 1
		current_tick = 0
		#if current_cycle % 2 == 0:
			#EventManager.start_event(Event.new())
		if current_tick == 0:
			print("new event start 0")
	#print("cycle:%s, tick:%s, time:%s, total:%s" % [current_cycle, current_tick, current_time, elapsed_time])


func _on_event_started(event):
	print("paused")
	paused = true


# Do stuff after event is resolved.
func _on_event_ended():
	paused = false
	print("unpaused")


func start_game():
	#print(get_tree().root.get_node("Main"))
	UI = get_tree().root.get_node("Main/%UI")
	get_tree().root.get_node("Main/%UI/%StartMenu").hide()
	EventManager.start_event(EventManager.current_event)


#func _on_play_button_pressed() -> void:
	#start_game()
