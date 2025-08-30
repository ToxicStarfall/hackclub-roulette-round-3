class_name EffectSet
extends Effect


@export var random: bool = false
@export var effects: Dictionary[float, Effect] = {}


func apply():
	if random:
		apply_random()
	else:
		for key in effects:
			var effect_chance = key
			var effect = effects[key]
			#var effect_key
			effect.apply()
			#if effect is ItemEffect:
				#key = Game.inventory.keys()[effect.item] # same item order in inventory when init as 0
			#var current_value = Game.inventory.get(key)
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


func apply_random():
	#var item_key = Game.inventory.keys()[item] # same item order in inventory when init as 0
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
	pass
