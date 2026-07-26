class_name CharacterData
extends Resource


signal stat_changed
#signal status_changed

enum Stat {
	HEALTH,
	HUNGER,
	THIRST,
	ENERGY
}
enum Hunger {
	STARVING, HUNGRY, BARELY_HUNGRY, FULL, STUFFED
}
enum Thirst {
	DEHYDRATED, THIRSTY, HYDRATED
}
enum Energy {
	EXHAUSTED, TIRED, NEUTRAL, ENERGETIC
}

#const EMPTY = 


var name: String = "Unknown Survivor"
#@export_range(20, 60) var age: int = 20
#@export var background: Backgrounds
#@export var traits: Array = []

var max_health := 100.0
var max_hunger := 100.0
var health := max_health
var hunger := max_hunger
#var thirst := 100.0
#var energy := 100.0
#var rest := 100.0  # Redundent with energy?

#var mood := 100.0

# Average movement speed in kilometres(km)
var walk_speed := 5.0  # (~3.0 mph)
#var run_speed := 12.5  # (~7.5 mph)

# - - Attributes - - #
var agility: int = 0  ## Affects travel speed, hunting.
var charisma: int = 0
var dexterity: int = 0
var endurance: int = 0
var intelligence: int = 0
var strength: int = 0
var social: int = 0

# - - - SKILLS - - - #
#@export_range(0, 3) var animals: float = 0.0  ## Affects ability to hunt and interact with ranimals
#@export_range(0, 3) var crafting: float = 0.0  ## Affects ability to create things from various materials.
#@export_range(0, 3) var combat: float = 0.0  ## Affects ability to fight and use combat gear.
#@export_range(0, 3) var medical: float = 0.0  ## Affects ability to treat wounds and diseases.
#@export_range(0, 3) var plants: float = 0.0  ## Affects ability to forage and use plants.
#@export_range(0, 3) var social: float = 0.0  ## Affects ability to trade and interact eith other humans.

#@export_range(0, 3) var axes: float = 0.0  ##
#@export_range(0, 3) var bows: float = 0.0  ##
#@export_range(0, 3) var knives: float = 0.0  ##
#@export_range(0, 3) var shields: float = 0.0  ##
#@export_range(0, 3) var spears: float = 0.0  ##
#@export_range(0, 3) var swords: float = 0.0  ##

#var info := CharacterInfo.new()
var stats := CharacterStats.new()

var inventory := InventoryComponent.new()




func _init() -> void:
	pass



func apply_stat(stat_type: Stat, value: float) -> void:
	var stat = Stat.keys().get(stat_type).to_lower()
	var new_value = min(max( stats.get(stat) + value, 0), 100)
	stats.set(stat, new_value)
	stat_changed.emit() # send ui update request after changing


func add_status():
	pass


func remove_status():
	pass


func get_stat(stat_type: Stat) -> float:
	var stat = Stat.keys().get(stat_type).to_lower()
	return stats.get(stat)


func get_efficiency(rounding_step: float = 0.1) -> float:
	const min_eff = 20
	const max_eff = 110
	var efficiency = 100
	
	# Efficiency debuff for health
	efficiency -= max((stats.max_health - stats.health)- 5, 0)  # Difference to max_health with +5 margin
	# Efficiency debuff for hunger
	efficiency -=max(((stats.max_hunger - stats.hunger)- 40) / 2, 0)  # Difference to max_hunger with +40 margin
	#print("hunger debuff", max(((stats.max_hunger - stats.hunger)- 40) / 2, 0))

	# Efficiency bonuses for high health and hunger.
	if stats.health == (stats.max_health * 1.0): efficiency += 10
	elif stats.health >= (stats.max_health * .95): efficiency += 5
	if stats.hunger >= (stats.max_hunger * 0.9): efficiency += 5

	return clamp( snapped(efficiency, rounding_step), min_eff, max_eff)


func get_hunger_rate() -> float:
	var hunger_rate = 1.0
	return hunger_rate


func get_movment_speed() -> float:
	var speed: float = stats.walk_speed
	#speed *= stats.health
	# speed modifiers
	return speed


func get_print():
	var text = \
		"Name: %s \
		\nHealth %s/%s, Hunger %s/%s \
		\nAttributes \
			\n\tagility: %s \
			\n\tcharisma: %s \
			\n\tdexterity: %s \
			\n\tendurance: %s \
			\n\tintelligence: %s \
			\n\tstrength: %s \
		\n%s \
		\n" % \
		[name,
		health, max_health, hunger, max_hunger,
			agility,
			charisma,
			dexterity,
			endurance,
			intelligence,
			strength,
		inventory.get_print()]
	return text


#static func empty() -> CharacterData:
	#var empty_char := CharacterData.new()
	#empty_char.
	#return empty_char
