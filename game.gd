extends Node


@warning_ignore_start("unused_signal")
#signal game_started
#signal game_ended

enum State {
	MENU, ACTIVE, EVENT
}

enum Location {
	GRASSLAND, FOREST, DESERT
}
const POSITIVE_LOCATION_AFFINITIES = {
	GRASSLANDS = ["meadows"],
	FOREST = ["animal_attack", "bandits"],
	DESERT = ["desert_winds"],
}
const NEGATIVE_LOCATION_AFFINITIES = {
	"GRASSLANDS": [],
	"FOREST": [],
	"DESERT": ["waters_path", "village"],
}

enum TravelEffects {
	SHELTERED,  # You are protected from the effects of the elements.
	EXPOSED,  # You are exposed to the effects of the elements.
	VISIBLE,  # You are visible to peering eyes.
	HIDDEN,  # You are hidden from peering eyes.
	URBAN,  # This area is densely populated.
	RURAL,  # This area is sparsely populated.
	#WILD,  # This area is heavily populated by wild creatures and insects.
	#TAME,  # This area is barely populated by wild creatures and insects.
	#DESOLATE,  # This area is devoid of plant life.
	#DRY, TROPICAL, COLD
}
enum TravelPath {
	TREACHEROUS, ROUGH, DECENT, SMOOTH, EASY
}
const ExclusiveEffects: PackedStringArray = [
	["SHELTERED", "EXPOSED"],
	["VISIBLE", "HIDDEN"],
]

enum Action {
	TRAVELING, FISHING, FORAGING, HUNTING, RESTING,
}

const GameSpeed = {
	#SLOW = 0.5,
	NORMAL = 1.0,
	FAST = 2.0,
	FASTER = 3.0,
	#FASTEST = 4.0
}

const EVENT_CHANCE = 0.25  # chance that a event occurs.

const SECONDS_PER_TICK = 1  # 1 second per tick
const TICKS_PER_HOUR = 10  # 10 ticks per hour
const HOURS_PER_DAY = 16  # 16 hours per day
const TICKS_PER_DAY = HOURS_PER_DAY * TICKS_PER_HOUR  # (160 ticks/seconds)

# Game time
var paused: bool = true
var game_speed := 1.0

var current_day: int = 0
var current_hour: int = 0
var current_tick: int = 0
var current_time: float = 0.0  ## Time system traacking
var elapsed_time: float = 0.0  ## Internal time tracking

var current_location: Region = Regions.Grasslands:
	set(value):
		current_location = value
		Events.location_changed.emit( current_location )
var current_action: Node
var action_tweener: Node
var allowed_actions: PackedInt32Array = [Action.TRAVELING, Action.HUNTING, Action.RESTING]
#var action_time_remaining: float = 0.0

# Distance in kilometres
const distance_total := 25.0  # Diastance travled to beat the game in km. Approximately 5 days
var distance_required := 0.0  ## Distance required to next checkpoint
var distance_travled := 0.0


#var party := Party.new()
var player := CharacterData.new()
var inventory := player.inventory


var UI: Control
var GameScreen: Control
var World: Node2D


func _ready() -> void:
	Events.game_started.connect( _on_game_start )
	#Events.game_ended
	EventManager.event_started.connect( _on_event_started )
	EventManager.event_ended.connect( _on_event_ended )

	#player.stat_changed.connect( GameScreen.get_node("%CharacterCard").update )
	#if get_tree().current_scene.name == "main":
	UI = get_tree().root.get_node("Main/%UI")
	World = get_tree().root.get_node("Main/World")
	GameScreen = UI.get_node("%GameScreen")


func _on_game_start():
	UI.get_node("%MainMenu").hide()
	UI.get_node("%GameScreen").show()
	GameScreen.get_node("%TravelProgress").max_value = TICKS_PER_DAY
	
	#GameScreen.get_node("%CharacterCard").set_character(player)
	#GameScreen.get_node("%CharacterCard").update()

	# - - Default Game Start Config - - #
	SaveManager.load_file()
	#EventManager.start_event("game/start")
	
	# - - Testing Configs - - #
	quickstart()
	player.apply_stat(CharacterData.Stat.HEALTH, -10)
	#EventManager.start_event("beggar")
	#EventManager.start_event("milestones/desert")
	
	var soldier = CharGen.generate_character(preload("res://data/characters/generator/soldier.tres"), 0)
	CombatManager.start( [soldier] )


## Skips character setup.
func quickstart():
	player.inventory.set_slot_config(preload("res://data/characters/inventory/slot_configs/human_config.tres"))
	player.apply_preset( Registries.PRESETS.load_entry("soldier") )
	player.name = "Survivor"
	
	
	GameScreen.get_node("%CharacterCard").set_character(player)
	unpause()


func _physics_process(delta: float) -> void:
	if !paused:
		elapsed_time = snapped(elapsed_time + delta, 0.001)
		current_time = snapped(current_time + delta, 0.01)

		# Tick counter
		if current_time * game_speed >= SECONDS_PER_TICK:
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
	#print("ay%s, hour:%s, tick:%s, time:%s, total:%s" % [current_day, current_hour, current_tick, current_time, elapsed_time])


func tick_tick():
	player.apply_stat( CharacterData.Stat.HUNGER, -0.40 )
	distance_travled += player.get_movment_speed() / TICKS_PER_DAY
	# UI updates
	Events.distance_changed.emit( snapped(distance_travled, 0.001) )
	GameScreen.get_node("%DistanceLabel").text = "%s km" % [ snapped(distance_travled, 0.001) ]
	GameScreen.get_node("%TravelProgress").value = (current_hour * TICKS_PER_HOUR) + current_tick

	if player.get_stat( CharacterData.Stat.HUNGER ) <= 0:
		player.apply_stat( CharacterData.Stat.HEALTH, -0.25 )
	if player.get_stat( CharacterData.Stat.HUNGER ) >= 75:
		player.apply_stat( CharacterData.Stat.HEALTH, +0.20 )

	if player.get_stat( CharacterData.Stat.HEALTH ) <= 0:
		EventManager.start_event("game/death")
	if distance_travled >= distance_total:
		EventManager.start_event("game/end")


func tick_hour():
	if current_hour == 8:
		EventManager.start_event("common/midday")
	if current_hour == 13:
		World.sunset()
	if randf() < EVENT_CHANCE:  # 25% chance every hour
		EventManager.start_event_random()


func tick_day():
	EventManager.start_event("common/night")
	#GameScreen.get_node("%DayLabel").text = "Day: %s" % [current_day]
	GameScreen.get_node("%TravelProgress").value = 0


func skip_tick(ticks: int = 1, rounded: bool = true):
	if rounded:
		current_time = 0.0
	current_tick += ticks
	#tick_tick()


func skip_hour(hours: int = 1, rounded: bool = true):
	if rounded:
		current_time = 0.0
		current_tick = 0
	#else:
	current_hour += hours
	tick_hour()


func skip_day(days: int = 1, rounded: bool = true):
	if rounded:
		current_time = 0.0
		current_tick = 0
		current_hour = 0
	#else:
	current_day += days
	tick_day()


# Do stuff after an event is started.
func _on_event_started(event: Event):
	Events.event_started.emit( event )
	pause()
	#if event.id == "village":
		#World.show_village()


# Do stuff after an event is resolved.
func _on_event_ended(event: Event):
	Events.event_ended.emit( event )
	unpause()

	if event.id == "common/night":
		pause()
		await Game.World.light_to_dark()
		await get_tree().create_timer(1.0).timeout
		await Game.World.dark_to_light()
		Events.day_changed.emit( current_day )
		EventManager.start_event("common/morning")
		SaveManager.save_file()
	if event.id == "common/morning": World.sunrise()
	#if event.id == "village":
		#World.hide_village()
	#if event.id in ["death","final"]:
		#paused = true


func pause():
	#print("paused")
	paused = true
	World.deactivate_parallax()


func unpause():
	#print("unpaused")
	paused = false
	World.activate_parallax()


func change_location(new_location: Region):
	current_location = new_location


func action_start(action: Action):
	pause()
	Events.action_started.emit( action )

	var ActionStatusContainer = GameScreen.get_node("%ActionStatusContainer")
	ActionStatusContainer.show()

	var tween_node = Node.new()
	tween_node.name = "ActionTweener"
	ActionStatusContainer.add_child( tween_node )
	current_action = tween_node

	var tween = tween_node.create_tween().set_loops(1)
	tween.tween_callback( func():
		ActionStatusContainer.get_node("RichTextLabel").text = Action.keys().get(action) + "... (%ss)" % [tween.get_loops_left() - 1]
		pass )
	tween.tween_interval(1.0)
	tween.finished.connect( action_end.bind(action) )


func action_end(action: Action = Action.TRAVELING, forced: bool = false):
	Events.action_ended.emit( action )
	current_action.queue_free()
	if forced:
		unpause()
	else:
		match action:
			#Action.FISHING: inventory.add(Items.FOOD)
			#Action.FORAGING: inventory.add(Items.FOOD)
			Action.HUNTING:
				EventManager.start_event("actions/hunt")
			Action.RESTING:
				EventManager.start_event("actions/rest")


func get_location_data() -> Dictionary:
	var data: Dictionary = {}
	#data.set("fauna", )
	return data
