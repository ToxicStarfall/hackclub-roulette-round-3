class_name Character
extends Entity


signal stat_changed

enum StatType {
	HEALTH,
	HUNGER,
	THIRST,
	ENERGY,
	#REST
}

var info = CharacterInfo.new()
var stats = CharacterStats.new()


func apply_stat(stat_type: StatType, value: float) -> void:
	var stat = StatType.keys().get(stat_type).to_lower()
	stats.set(stat, value)
	stat_changed.emit() # send ui update request after changing


func get_stat(stat_type: StatType) -> float:
	var stat = StatType.keys().get(stat_type).to_lower()
	return stats.get(stat)


func get_movment_speed() -> float:
	var speed: float = stats.walk_speed
	# speed modifiers
	return speed
