class_name ItemEffect
extends Effect


#@export var item: Game.Items  # item string name
@export var value: float = 1.0  ##
#@export var value_min: float = 1.0
@export var modifier: Modifiers = Modifiers.ADD


#func apply():
	#if chance_check():
		#var item_key = Game.inventory.keys()[item] # same item order in inventory when init as 0
		##var current_value = Game.inventory.get(item)
		#var current_value = Game.inventory.get(item_key)
		#var new_value
		#if modifier == Modifiers.ADD:
			#new_value = current_value + value
		#elif modifier == Modifiers.SUBTRACT:
			#new_value = current_value - value
		#elif modifier == Modifiers.MULTIPLY:
			#new_value = current_value * value
		#elif modifier == Modifiers.DIVIDE:
			#new_value = current_value / value
		#Game.inventory.set(item_key, new_value)
#
		#EventManager.dialogue_requested.emit("", outcome_1)
	#else:
		#EventManager.dialogue_requested.emit("", outcome_2)
