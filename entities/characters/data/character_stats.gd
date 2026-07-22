class_name CharacterStats
extends Resource


#const HEALTH = "health"
#const HUNGER = "hunger"
#const THIRST = "thirst"
#const ENERGY = "energy"

@export var max_health := 100.0
@export var max_hunger := 100.0
var health := max_health
var hunger := max_hunger
#@export var thirst := 100.0
#@export var energy := 100.0
#@export var rest := 100.0  # Redundent with energy?

#@export var mood := 100.0

# Average movement speed in kilometres(km)
@export var walk_speed := 5.0  # (~3.0 mph)
@export var run_speed := 12.5  # (~7.5 mph)

#@export_group("Attributes")
@export var agility := 3.0  ## Affects travel speed, hunting.
@export var charisma := 3.0
@export var dexterity := 3.0
@export var endurance := 3.0
@export var intelligence := 3.0
@export var strength := 3.0
#@export var social := 3.0

#@export_group("Skills")
#@export_range(0, 3) var animals := 1.0  ## Affects ability to hunt and interact with ranimals
#@export_range(0, 3) var crafting := 1.0  ## Affects ability to create things from various materials.
#@export_range(0, 3) var combat := 1.0  ## Affects ability to fight and use combat gear.
#@export_range(0, 3) var medical := 1.0  ## Affects ability to treat wounds and diseases.
#@export_range(0, 3) var plants := 1.0  ## Affects ability to forage and use plants.
#@export_range(0, 3) var social := 1.0  ## Affects ability to trade and interact eith other humans.

#@export_range(0, 3) var axes := 1.0  ##
#@export_range(0, 3) var bows := 1.0  ##
#@export_range(0, 3) var knives := 1.0  ##
#@export_range(0, 3) var shields := 1.0  ##
#@export_range(0, 3) var spears := 1.0  ##
#@export_range(0, 3) var swords := 1.0  ##
