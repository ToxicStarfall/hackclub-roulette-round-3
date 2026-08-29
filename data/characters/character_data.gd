class_name CharacterData
extends Resource


signal stat_changed (stat: Stat)
#signal status_changed
signal killed (character: CharacterData)


enum Stat {
	HEALTH, HUNGER, THIRST, ENERGY
}
enum Hunger {
	STARVING, HUNGRY, SLIGHTLY_HUNGRY, FULL, STUFFED
}
enum Thirst {
	DEHYDRATED, THIRSTY, HYDRATED
}
enum Energy {
	EXHAUSTED, TIRED, NEUTRAL, ENERGETIC
}

enum Attribute {
	NONE,
	AGILITY,
	CHARISMA,
	DEXTERITY,
	ENDURANCE,
	INTELLIGENCE,
	STRENGTH,
	#SOCIAL,
}
enum Efficiency {
	NONE, ACTION, CARRY, MOVEMENT, HEALING
}


var name: String = "Character"
#@export_range(20, 60) var age: int = 20
#@export var background: Backgrounds
#@export var traits: Array = []

# - - ATTRIBUTES - - #
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

# - - - CHARACTER FUNCTIONS - - - #
var max_health := 30.0
var max_hunger := 100.0
var health := max_health
var hunger := max_hunger
#var thirst := 100.0
#var energy := 100.0
#var rest := 100.0  # Redundent with energy?
#var mood := 100.0

var action_efficiency := 100.0
var carry_efficiency := 100.0
var movement_efficiency := 100.0


# Average movement speed in kilometres(km)
var walk_speed := 5.0  # (~3.0 mph)
#var run_speed := 12.5  # (~7.5 mph)

var carry_weight_base = 25.0
var carry_weight = 25.0
#var underweight_threshold = 10.0  ## Margin for lightweight status. 
#var overweight_threshold = 10.0  ## Margin for overweight status.
#var overweight_maximum = 20.0  ## Margin for overweight


#var stats := CharacterStats.new()
#var slots: Array
var statuses: Array[StatusEffect] = []
var inventory: InventoryComponent



func _init() -> void:
	inventory = InventoryComponent.new()

	stat_changed.connect( _on_stat_changed )
	pass


func apply_preset(preset: CharacterPreset):
	name = preset.name
	
	agility = preset.agility
	charisma = preset.charisma
	dexterity = preset.dexterity
	endurance = preset.endurance
	intelligence = preset.intelligence
	strength = preset.strength
	#social = preset.social
	
	for i in preset.items.size():
		inventory.add(preset.items[i], preset.quantities[i])


func apply_stat(stat_type: Stat, value: float) -> void:
	var stat: String = Stat.keys().get(stat_type).to_lower()  # Get stat type from enum keys.
	#var new_value = min(max( get(stat) + value, 0), 100)
	var new_value = clamp( get(stat) + value, 0, get("max_"+stat) )
	set(stat, new_value)
	stat_changed.emit(stat_type)  # Send ui update request after changing


func add_status(status: StatusEffect):
	statuses.append(status)


func remove_status(status: StatusEffect):
	statuses.erase(status)


func _on_stat_changed(stat_type: Stat):
	match stat_type:
		Stat.HEALTH:
			if get_stat(stat_type) <= 0:
				killed.emit(self)
			pass
		Stat.HUNGER:
			pass


## Returns attribute value
func get_attribute(attr: Attribute):
	var attribute = get( Attribute.keys().get(attr).to_lower() )
	return attribute


func get_stat(stat_type: Stat) -> float:
	var stat = Stat.keys().get(stat_type).to_lower()
	return get(stat)


#TODO Add more efficiency modifiers.
#func get_efficiency(rounding_step: float = 0.1) -> float:
	#const min_eff = 20
	#const max_eff = 110
	#var efficiency = 100
	#
	## Efficiency debuff for health
	#efficiency -= max((max_health - health)- 5, 0)  # Difference to max_health with +5 margin
	## Efficiency debuff for hunger
	#efficiency -=max(((max_hunger - hunger)- 40) / 2, 0)  # Difference to max_hunger with +40 margin
	##print("hunger debuff", max(((stats.max_hunger - stats.hunger)- 40) / 2, 0))
#
	## Efficiency bonuses for high health and hunger.
	#if health == (max_health * 1.0): efficiency += 10
	#elif health >= (max_health * .95): efficiency += 5
	#if hunger >= (max_hunger * 0.9): efficiency += 5
#
	#return clamp( snapped(efficiency, rounding_step), min_eff, max_eff)
	
func get_efficiency(eff_type: Efficiency) -> float:
	var value = get( Efficiency.keys().get(eff_type).to_lower() + "_efficiency")
	return value


func get_item_comp(item_id: StringName):
	#print(item_id)
	var item = Registries.ITEMS.load_entry(item_id).duplicate()
	if item is WeaponData or item is ArmorData:
		var attribute = CharacterData.Attribute.keys()[item.primary_attribute].to_lower()
		# TODO - Item strength requirements?
		# +1 bonus damage per extra strength over item tier
		# Max bonus damage capped to (item tier + 2)
		item.damage += min(get(attribute) - item.tier, 2 + item.tier)
	return item


func get_hunger_rate() -> float:
	var hunger_rate = 1.0
	return hunger_rate


#TODO Apply body part efficiency
func get_movment_speed() -> float:
	var speed: float = walk_speed
	#speed *= stats.health
	# speed modifiers
	return speed


## Returns the character data in a printable text format.
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
	
	
