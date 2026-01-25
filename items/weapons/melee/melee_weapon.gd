class_name MeleeWeapon
extends Weapon


## The angle in degrees that which entities or objects can be hit
@export_range(0, 360) var hit_angle: float = 0.0


var entities_in_range = []


func _ready() -> void:
	self.body_entered.connect( _on_body_entered )
	self.body_exited.connect( _on_body_exited )


#func _setup():
	#if has_node("AttackComponent"): AttackComp = $AttackComponent
	#self.monitorable = false


func _on_body_entered(body):
	#if body
	entities_in_range.append(body)


func _on_body_exited(body):
	#if body
	entities_in_range.erase(body)


# OVERIDE
func _attack():
	self.monitorable = true
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "rotation_degrees", rotation_degrees + 30 + 120, 0.2)
	#tween.tween_property(self, "modulate", modulate - Color(0,0,0,1), 0.5)
	await tween.finished
	#tween.tween_callback( func(): self.monitorable = false ).set_delay()
	self.monitorable = false
	#$AnimationPlayer.play("sword_swing")
	pass


func get_damage():
	if AttackComp: return AttackComp.DamageComp
