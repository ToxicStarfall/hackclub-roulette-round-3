@tool
class_name CharGen
extends Node



@export var sample_template: CharGenTemplate
@export var sample_tier: int = 0
@export_tool_button("Sample") var sample = _sample


## Generate semi-randomized character based on a preset.
func generate_character(from: CharGenTemplate, char_tier: int):
	var template = from
	var total_attr_points = template.attr_points + (template.attr_points_per_level * char_tier)
	
	var new_char = CharacterData.new()
	fill_attributes(new_char, template.get_attr_weights(), total_attr_points)
	
	print( new_char.get_print() )
	pass
	

func fill_attributes(character: CharacterData, attr_weights: Array, attr_points: int):
	#var total_weight: float
	var attr_list = ["agility", "charisma", "dexterity", "endurance", "intelligence", "strength"]
	#attr_weights.map( func(value): total_weight += value)
	
	var rng := RandomNumberGenerator.new()
	for i in attr_points:
		var sample = rng.rand_weighted(attr_weights)
		var attribute = attr_list[sample]
		character.set(attribute, character.get(attribute) + 1)
	
	#var sample = randf_range(0, total_weight)
	#var prev_weights = 0.0
	#for weight in attr_weights:
		#if sample < weight + prev_weights:
			#pass
		#else:
			#prev_weights += weight
	
	pass


func _sample():
	if sample_template:
		generate_character(sample_template, sample_tier)
	else:
		print("[CharGen] No valid character template")
