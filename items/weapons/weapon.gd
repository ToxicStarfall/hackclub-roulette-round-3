class_name Weapon
extends Item
#extends Node2D


#@export var icon: Texture2D = preload("res://icon.svg")
#@export_multiline var description: String = ""

@export var attack_cooldown: float = 0.5
@export var cooldown_disabled: bool = false
var cooldown_timer: Timer = Timer.new()#: float = 0.0
var cooldown_active: bool = false

var AttackComp: AttackComponent

#var user: Entity



func _ready() -> void:
	_setup()


func _setup():
	user = get_parent()
	if has_node("AttackComponent"): AttackComp = $AttackComponent

	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = attack_cooldown
	cooldown_timer.timeout.connect( func(): cooldown_active = false )
	add_child(cooldown_timer)


func _physics_process(_delta: float) -> void:
	if cooldown_active:
		#cooldown_timer
		pass


func use():
	if !cooldown_active:
		cooldown_active = true
		cooldown_timer.start()
		#var cooldown = get_tree().create_timer(attack_cooldown)
		#cooldown_timer = get_tree().create_timer(attack_cooldown)
		#cooldown_timer = cooldown.time_left
		_attack()


func alt_use():
	_alt_attack()


func _attack():
	pass


func _alt_attack():
	pass


func get_damage():
	return
