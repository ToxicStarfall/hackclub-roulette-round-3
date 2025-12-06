extends Node


signal game_started
signal game_ended

signal character_added

enum State {
	MENU, ACTIVE, EVENT
}

enum Items {
	MEDICINE,
	RATIONS,
	WATER,
	WEAPONS,
}

const TOTAL_CYCLES = 10  # 1 cycle = day/night.
const TICKS_PER_CYCLE = 24.0  # 1 tick = 1 second.
const SECONDS_PER_TICK = 3.0 #5.0  #

const EVENT_CHANCE_PER_TICK = 0.40 #0.10  # chance that a event occurs.
const NOTABLE_EVENT_CHANCE = 0.25  # chance for a important event.

# Game time
var paused: bool = true
var current_cycle: int = 0
var current_tick: int = 0
var current_time: float = 0.0
var elapsed_time: float = 0.0

# Distance in kilometres
const distance_total = 250.0
var distance_required = 0.0  ## Distance required to next checkpoint
var distance_travled = 0.0

#var speed_mod = 1.0

var player := Character.new()
#var characters := []

var inventory := InventoryComponent.new()

var toggles = {
	"gamble": false
}

@onready var UI: Control = get_tree().root.get_node("Main/%UI")
@onready var World: Node2D = get_tree().root.get_node("Main/World")


func _ready() -> void:
	#State.MENU
	game_started.connect( _on_game_start )
	EventManager.event_started.connect( _on_event_started )
	EventManager.event_ended.connect( _on_event_ended )

	DialogueManager.passed_title.connect( func(title): print(title) )
	player.stat_changed.connect( UI.get_node("%CharacterCard").update )

	inventory.add(Items.GOLD, 1)
	print(inventory.get_item(Items.GOLD))


	#player.apply_stat( Character.StatType.HEALTH, -10 )
	#var resource = preload("res://events/dialogues/a.dialogue")
	#var diag = await DialogueManager.get_next_dialogue_line(resource, "start")
	#UI.get_node("%DistanceLabel").text = diag.text


func _on_game_start():
	UI.get_node("%StartMenu").hide()
	UI.get_node("%CharacterCard").update()

	# Game.add character

	EventManager.start_event("start")
	#EventManager.load_event("res://events/dialogues/new_journey.tres")
	#EventManager.load_event("res://events/dialogues/village.tres")


func _physics_process(delta: float) -> void:
	if !paused:
		elapsed_time = snapped(elapsed_time + delta, 0.001)
		current_time = snapped(current_time + delta, 0.01)

		if current_time >= SECONDS_PER_TICK:
			current_tick += 1
			current_time = 0.0  # Reset tick timer

			# Every 4th tick is chance for event
			if current_tick % 4 == 0:
				if randf() <= EVENT_CHANCE_PER_TICK:
					#paused = true
					#if randf() <= notable_event_chance:
						#EventManager.start_event(load("res://events/event_1.tres"))
					#else:
						#EventManager.start_event(load("res://events/event_1.tres"))
					#EventManager.load_random_event()
					print("new event start rand")
			UI.get_node("%TravelProgress").value = current_tick
		# ON DEATH
		if player.stats.health <= 0:
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
	print("unpaused")
	paused = false
	World.activate_parallax()
	var event_file_name = event.resource_path.split("/")[-1].split(".")[0]
	print(event_file_name)
	if event_file_name == "village":
		World.hide_village()
	if event_file_name in ["death","final"]:
		paused = true
