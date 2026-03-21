class_name Character
extends Entity


signal stat_changed

enum Stat {
	HEALTH,
	HUNGER,
	THIRST,
	ENERGY
}

var info = CharacterInfo.new()
var stats = CharacterStats.new()


func apply_stat(stat_type: Stat, value: float) -> void:
	var stat = Stat.keys().get(stat_type).to_lower()
	var new_value = min(max( stats.get(stat) + value, 0), 100)
	stats.set(stat, new_value)
	stat_changed.emit() # send ui update request after changing


func get_stat(stat_type: Stat) -> float:
	var stat = Stat.keys().get(stat_type).to_lower()
	return stats.get(stat)


func get_efficiency(rounding_step: float = 0.1) -> float:
	var efficiency = 100
	# Efficiency debuff for health
	efficiency -= max((stats.max_health - stats.health)- 5, 0)  # Efficiency debuff for health
	# Efficiency debuff for hunger
	efficiency -=max(((stats.max_hunger - stats.hunger)- 40) / 2, 0)  # Difference to max_hunger with +40 margin
	#print("hunger debuff", max(((stats.max_hunger - stats.hunger)- 40) / 2, 0))

	if stats.health == (stats.max_health * 1.0): efficiency += 10
	elif stats.health >= (stats.max_health * .95): efficiency += 5
	if stats.hunger >= (stats.max_hunger * 0.9): efficiency += 5

	return clamp( snapped(efficiency, rounding_step), 20, 110)


func get_hunger_rate() -> float:
	var hunger_rate = 1.0
	return hunger_rate


func get_movment_speed() -> float:
	var speed: float = stats.walk_speed
	#speed *= stats.health
	# speed modifiers
	return speed
