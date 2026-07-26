@tool
class_name CharGen
extends Node



@export var sample_template: CharGenTemplate
@export var sample_tier: int = 0
@export_tool_button("Sample") var sample_button = _sample



## Generate semi-randomized character based on a preset.
func generate_character(from: CharGenTemplate, char_tier: int):
	var template: CharGenTemplate = from
	var attribute_points: int = template.attr_points + (template.attr_points_per_level * char_tier)
	var character: CharacterData = CharacterData.new()
	
	var attr_list = ["agility", "charisma", "dexterity", "endurance", "intelligence", "strength"]
	
	# Fill base attributes.
	for attribute in attr_list:
		character.set(attribute, character.get(attribute) + template.get_base_attributes()[attr_list.find(attribute)])
	
	# Fill attributes from available attribute points.
	var rng := RandomNumberGenerator.new()
	for i in attribute_points:
		var sample = rng.rand_weighted( template.get_attr_weights() )
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
