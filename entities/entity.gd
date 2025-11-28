class_name Entity
extends CharacterBody2D
#extends Node2D

signal entity_death
signal entity_created
signal entity_projectile_created


#enum Hostility {}
enum Faction {
	NONE,
	NEUTRAL,
	ALLY,
	ENEMY,
}

#@export_category("Attributes")  #@export_group("Atributes")
## Damage dealt to incomming projectile on contact
@export var projectile_damage = 1

@export var faction: Faction = Faction.NEUTRAL

@export var DamageParticles = preload("res://effects/particles/blood.tscn")
@export var DeathParticles = preload("res://effects/particles/blood.tscn")

@export_group("Targets")
#@export var targets_player: bool = true
@export var TargetComp: TargetingComponent
#@export var entity_targets: Array[Entity]
#@export var faction_targets: Array[Entity]

@export_group("Traits")
@export var damageable: bool = true
@export var healable: bool = true
@export var killable: bool = true
#@export var imunities

var HitboxComp: HitboxComponent
var HealthComp: HealthComponent
var AttackComp: AttackComponent
#var MovementComp: MovementComponent

var Inventory: InventoryComponent


func _ready() -> void:
	setup()


## Initialize and checks for entity components.
func setup():
	if has_node("HitboxComponent"): HitboxComp = $HitboxComponent
	if has_node("HealthComponent"): HealthComp = $HealthComponent
	if has_node("AttackComponent"): AttackComp = $AttackComponent
	#if has_node("MovementComponent"): MovementComp = $MovementComponent

	if HitboxComp:
		HitboxComp.hit.connect( _on_hitbox_hit )
	if HealthComp:
		HealthComp.health_damaged.connect( _on_health_damaged )
		HealthComp.health_zero.connect( _on_health_zero )
	# if AttackComp:
	# 	AttackComp
	#if MovementComp:
		#MovementComp

	if DamageParticles:
		DamageParticles = DamageParticles.instantiate()
		add_child(DamageParticles)
	if DeathParticles:
		DeathParticles = DeathParticles.instantiate()
		add_child(DeathParticles)

	add_to_group( get_faction() )
	add_to_group("entities")


func _on_hitbox_hit(damage: Damage):
	if damageable:
		HealthComp.apply_damage(damage)
	else: print(self, " is immune.")


# Damage effects
func _on_health_damaged(amount):
	if DamageParticles: DamageParticles.emitting = true

	var t = create_tween()
	t.tween_property(self, "modulate", Color(1, 0, 0), 0.1)
	t.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	#print(self)
	#if self is not Player:
	get_parent().add_child( DamageNumber.new(self.position, amount) )  # Damage numbers


func _on_health_zero():
	if killable:
		kill()
	else: print(self, " is immortal.")


# Corpse, death effects, deletion
func kill():
	#print(self, " killed.")
	$Sprite2D.hide()
	$HitboxComponent.queue_free()
	$CollisionShape2D.queue_free()
	self.velocity = Vector2.ZERO

	#if self is Enemy:
		#get_parent().score += 5
	if self is Player: get_parent().game_loss()
	#else:
	entity_death.emit( self )
	if DeathParticles:
		DeathParticles.emitting = true
		await DeathParticles.finished
	queue_free()


func give_item():
	pass

#func take_item():
	#pass


func get_health():
	if HealthComp: return HealthComp.health


func get_damage():
	if AttackComp: return AttackComp.DamageComp


func get_faction():
	if faction == Faction.NEUTRAL: return "FactionNeutral"
	if faction == Faction.ALLY: return "FactionAlly"
	if faction == Faction.ENEMY: return "FactionEnemy"


func get_target(_target_filter):
	pass
