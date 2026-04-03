class_name Party
extends Resource


@warning_ignore_start("unused_signal")
signal member_added
signal member_removed
signal party_changed()
@warning_ignore_restore("unused_signal")


var members: Array[Character] = []
var inventory: InventoryComponent


## Adds a new character to the party.
func add_member(member: Character):
	members.append(member)
	member_added.emit(member)

## Removes a character from the party.
func remove_member(member: Character):
	members.erase(member)
	member_removed.emit(member)


func get_members() -> Array:
	return members


func get_member_count() -> float:
	return members.size()


func get_party_efficiency() -> float:
	var total_efficiency = 0.0
	for member in members:
		total_efficiency += member.get_efficiency()
	var party_efficiency = total_efficiency / get_member_count()
	return party_efficiency


func get_party_speed() -> float:
	var total_speed := 0.0
	for member in members:
		total_speed += member.get_movment_speed()
	return total_speed / get_party_count()


func get_party_count() -> int:
	return members.size()
