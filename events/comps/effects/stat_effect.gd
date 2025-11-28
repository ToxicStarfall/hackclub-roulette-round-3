class_name StatEffect
extends Effect

@export var stat: Game.Stats
@export var value: float = 1.0  ##
#@export var value_min: float = 1.0
@export var modifier: Modifiers = Modifiers.ADD


func apply():
	if chance_check():
		var stat_key = Game.stats.keys()[stat] # same item order in inventory when init as 0
		#var current_value = Game.inventory.get(item)
		var current_value = Game.stats.get(stat_key)
		var new_value
		if modifier == Modifiers.ADD:
			new_value = current_value + value
		elif modifier == Modifiers.SUBTRACT:
			new_value = current_value - value
		elif modifier == Modifiers.MULTIPLY:
			new_value = current_value * value
		elif modifier == Modifiers.DIVIDE:
			new_value = current_value / value
		#Game.stats.set(stat_key, new_value)
		Game.player.Stats.set(stat_key, new_value)

		EventManager.dialogue_requested.emit("", outcome_1)
	else:
		EventManager.dialogue_requested.emit("", outcome_2)
