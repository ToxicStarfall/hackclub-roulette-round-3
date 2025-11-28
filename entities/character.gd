class_name Character
extends Entity


#enum Stats {
	#HEALTH,
	#REST,
#}

var Info = CharacterInfo.new()
var Stats = CharacterStats.new()


func apply_thirst():
	pass

func apply_hunger():
	pass

func apply_energy():
	pass

func apply_rest():
	pass


func get_movment_speed() -> float:
	var speed: float = Stats.walk_speed
	# speed modifiers
	return speed
