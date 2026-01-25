class_name DamageNumber
extends Label


var velocity: Vector2 = Vector2(0, -50)
var tilt


#func _setup():
	#self.add_theme_font_size_override())


func _init(initial_position, damage_amount, _damage_severity = "normal") -> void:
	#_setup()
	self.position = initial_position
	self.text = str(damage_amount)


func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	#velocity.y -= delta
	self.position += velocity * delta

#func set_damage_amount(damage):
	#self.text = str(damage)
	#return self
