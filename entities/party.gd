class_name Party
extends Resource


@warning_ignore_start("unused_signal")
signal member_added (member: CharacterData)
signal member_removed (member: CharacterData)
signal member_killed (member: CharacterData)
signal party_changed ()
signal party_defeated ()
@warning_ignore_restore("unused_signal")


var members: Array[CharacterData] = []
var inventory: InventoryComponent


## Adds a new character to the party.
func add_member(new_member: CharacterData):
	members.append(new_member)
	new_member.killed.connect( _on_member_killed )
	member_added.emit(new_member)


func add_members(new_members: Array[CharacterData]):
	members = members + new_members
	for member in new_members:
		member.killed.connect( _on_member_killed )
		member_added.emit(member)


## Removes a character from the party.
func remove_member(member: CharacterData):
	members.erase(member)
	member.killed.disconnect( _on_member_killed )
	member_removed.emit(member)


# TODO - Add handling for enemy surrender or fleeing.
## Returns true if all members are killed (0 health).
func is_defeated() -> bool:
	var defeated = true
	for member in members:
		if member.health > 0:
			defeated = false
			break
	return defeated


func _on_member_killed(member):
	member_killed.emit(member)
	
	if is_defeated():
		party_defeated.emit()


func get_members() -> Array:
	return members


func get_member_count() -> float:
	return members.size()


func get_attribute_total(attribute: CharacterData.Attribute) -> int:
	var attr_total: int = 0
	for i in get_members():
		var member: CharacterData = i
		attr_total = member.get_attribute(attribute)
	return attr_total


func get_efficiency_total(efficiency: CharacterData.Efficiency) -> float:
	var eff_total: float = 0
	for i in get_members():
		var member: CharacterData = i
		eff_total = member.get_efficiency(efficiency)
	return eff_total


#func get_party_efficiency() -> float:
	#var total_efficiency = 0.0
	#for member in members:
		#total_efficiency += member.get_efficiency()
	#var party_efficiency = total_efficiency / get_member_count()
	#return party_efficiency


func get_party_speed() -> float:
	var total_speed := 0.0
	for member in members:
		total_speed += member.get_movment_speed()
	return total_speed / get_member_count()


#func get_party_count() -> int:
	#return members.size()
