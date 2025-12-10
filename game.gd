extends Node


signal game_started
signal game_ended

#signal character_added

enum State {
	MENU, ACTIVE, EVENT
}

const EVENT_CHANCE_PER_TICK = 0.30  # chance that a event occurs.
#const NOTABLE_EVENT_CHANCE = 0.25  # chance for a important event.

#const TOTAL_CYCLES = 10  # 1 cycle = day/night.
const HOURS_PER_DAY = 16.0  # 16 hours per day
const TICKS_PER_HOUR = 10.0  # 10 ticks per hour
const SECONDS_PER_TICK = 1.0  # 1 second per tick

# Game time
var paused: bool = true

var current_day: int = 0
var current_hour: int = 0
var current_tick: int = 0

var current_time: float = 0.0
var elapsed_time: float = 0.0

# Distance in kilometres
const distance_total := 250.0
var distance_required := 0.0  ## Distance required to next checkpoint
var distance_travled := 0.0

#var speed_mod = 1.0

#var party := Party.new()
var player := Character.new()
var inventory := InventoryComponent.new()

#var toggles = {
	#"gamble": false
#}

@onready var UI: Control = get_tree().root.get_node("Main/%UI")
@onready var World: Node2D = get_tree().root.get_node("Main/World")


func _ready() -> void:
	game_started.connect( _on_game_start )

	EventManager.event_started.connect( _on_event_started )
	EventManager.event_ended.connect( _on_event_ended )

	player.stat_changed.connect( UI.get_node("%CharacterCard").update )
	#inventory.add(Items.GOLD, 1)


func _on_game_start():
	UI.get_node("%StartMenu").hide()
	UI.get_node("%TravelProgress").max_value = HOURS_PER_DAY
	UI.get_node("%CharacterCard").update()

	# Game.add character
	#EventManager.start_event("start")
	EventManager.start_event("animal_attack")


func _physics_process(delta: float) -> void:
	if !paused:
		elapsed_time = snapped(elapsed_time + delta, 0.001)
		current_time = snapped(current_time + delta, 0.01)

		# Tick counter
		if current_time >= SECONDS_PER_TICK:
			current_time = 0.0
			current_tick += 1
			tick_tick()

		# Hour counter
		if current_tick >= TICKS_PER_HOUR:
			current_tick = 0
			current_hour += 1
			tick_hour()

		# Day counter
		if current_hour >= HOURS_PER_DAY:
			current_hour = 0
			current_day += 1
			tick_day()

		# Player daeth
		if player.stats.health <= 0:
			EventManager.load_event("res://events/dialogues/death.tres")
	#print("ay%s, hour:%s, tick:%s, time:%s, total:%s" % [current_day, current_hour, current_tick, current_time, elapsed_time])


func tick_tick():
	distance_travled += player.get_movment_speed() / TICKS_PER_HOUR
	UI.get_node("%DistanceLabel").text = "%s km" % [distance_travled]
	UI.get_node("%TravelProgress").value = current_tick

	if distance_travled >= distance_total:
		EventManager.start_event("end")


func tick_hour():
	pass


func tick_day():
	EventManager.start_event("night")
	UI.get_node("%DayLabel").text = "Day: %s" % [current_day]
	UI.get_node("%TravelProgress").value = 0


# Do stuff after an event is started.
func _on_event_started(event: Event2):
	#print("paused")
	paused = true
	World.deactivate_parallax()
	#if event.resource_path.split("/")[-1].split(".")[0] == "village":
		#World.show_village()


# Do stuff after an event is resolved.
func _on_event_ended(event: Event2):
	#print("unpaused")
	paused = false
	World.activate_parallax()
	#var event_file_name = event.resource_path.split("/")[-1].split(".")[0]
	#print(event_file_name)
	#if event_file_name == "village":
		#World.hide_village()
	#if event_file_name in ["death","final"]:
		#paused = true
