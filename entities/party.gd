class_name Party
extends Resource


@warning_ignore_start("unused_signal")
signal member_added
signal member_removed
signal party_changed()
@warning_ignore_restore("unused_signal")


var members: Array[Character] = []
var inventory: InventoryComponent


func add_member(member: Character):
	members.append(member)
	member_added.emit(member)


func remove_member(member: Character):
	members.erase(member)
	member_removed.emit(member)


func get_members() -> Array:
	return members


func get_party_speed() -> float:
	var total_speed := 0.0
	for member in members:
		total_speed += member.get_movment_speed()
	return total_speed / get_party_count()


func get_party_count() -> int:
	return members.size()
