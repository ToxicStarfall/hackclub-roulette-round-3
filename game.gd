extends Node

enum Items {
	GOLD,
	MEDICINE,
	RATIONS,
	WATER,
	WEAPONS,
}
enum Stats {
	HEALTH,
	REST,
}

const TOTAL_CYCLES = 10  # 1 cycle = day/night.
const TICKS_PER_CYCLE = 24.0  # 1 tick = 1 second.
const SECONDS_PER_TICK = 3.0 #5.0  #

const EVENT_CHANCE_PER_TICK = 0.40 #0.10  # chance that a event occurs.
const NOTABLE_EVENT_CHANCE = 0.25  # chance for a important event.

var paused: bool = true
var current_cycle = 0
var current_tick = 0
var current_time = 0.0
var elapsed_time = 0.0

var speed_mod = 1.0

var characters = []
var stats = {
	"health": 100,
}
var inventory = {
	"gold": 0,
	"medicine": 0,
	"rations": 0,
	"water": 0,
}
var toggles = {
	"gamble": false
}


var UI: Control
var World: Node2D


func _ready() -> void:
	EventManager.event_started.connect( _on_event_started )
	EventManager.event_ended.connect( _on_event_ended )


func _physics_process(delta: float) -> void:
	if !paused:
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
					#EventManager.start_event(Event.new())
					EventManager.load_random_event()
					print("new event start rand")
			UI.get_node("%TravelProgress").value = current_tick
		# ON DEATH
		if stats.health <= 0:
			EventManager.load_event("res://events/dialogues/death.tres")

	if current_tick >= TICKS_PER_CYCLE:
		current_cycle += 1
		current_tick = 0
		UI.get_node("%DayLabel").text = "Day: " + str(current_cycle)
		if current_cycle == TOTAL_CYCLES:
			EventManager.load_event("res://events/dialogues/final.tres")
			World.show_final_village()
		#if current_cycle % 2 == 0:
			#EventManager.start_event(Event.new())
		elif current_tick == 0:
			EventManager.load_event("res://events/dialogues/a_nights_rest.tres")
			UI.get_node("%TravelProgress").value = 0
	#print("cycle:%s, tick:%s, time:%s, total:%s" % [current_cycle, current_tick, current_time, elapsed_time])


# Do stuff after an event is started.
func _on_event_started(event):
	print("paused")
	paused = true
	World.deactivate_parallax()
	if event.resource_path.split("/")[-1].split(".")[0] == "village":
		World.show_village()

# Do stuff after an event is resolved.
func _on_event_ended(event):
	paused = false
	World.activate_parallax()
	var event_file_name = event.resource_path.split("/")[-1].split(".")[0]
	if event_file_name == "village":
		World.hide_village()
	if event_file_name in ["death","final"]:
		paused = true
	print("unpaused")


func start_game():
	UI = get_tree().root.get_node("Main/%UI")
	UI.get_node("%StartMenu").hide()
	World = get_tree().root.get_node("Main/World")
	print(World)
	EventManager.load_event("res://events/dialogues/new_journey.tres")
	#EventManager.load_event("res://events/dialogues/village.tres")
