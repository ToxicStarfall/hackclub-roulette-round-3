class_name Player
extends Entity


#signal item_equipped
signal item_used

signal controller_movement_input


enum Actions {
	NONE, CONTROLLING
}

@export var movement_speed: float = 200.0
#@export var equipped_weapon: Weapon
@export var equipped_item: Item
@export var inventory: Array[Weapon] = []

var InputComponent

var action: Actions = Actions.NONE
var using_item: bool = false


func _process(_delta: float) -> void:
	if equipped_item:
		aim_item()
		if using_item:
			equipped_item.use()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		using_item = true
	if event.is_action_released("use"):
		using_item = false
	#if Input.is_action_just_pressed("alt_use"):
		#equipped_weapon.alt_use()
	#if Input.is_action_just_pressed("swap_weapons"):
		#swap_slots()

	if event is InputEventKey:
		var key = event.as_text_key_label()
		if key.is_valid_int():
			var inv_idx = int(key)
			if inv_idx > 0 and inv_idx <= inventory.size() and !inventory.is_empty():
				var item = inventory.get(inv_idx - 1)
				equip_item(item)


func _physics_process(_delta: float) -> void:
	var xdir = Input.get_axis("move_left", "move_right")
	var ydir = Input.get_axis("move_up", "move_down")

	# Diagonal movement
	if xdir and ydir:
		var normal = Vector2(xdir, ydir).normalized()
		xdir = normal.x
		ydir = normal.y

	# Movement check
	if xdir or ydir:
		if action == Actions.CONTROLLING:
			controller_movement_input.emit( Vector2(xdir, ydir) )
		else:
			#if velocity == Vector2.ZERO:
				#$AnimatedSprite2D.play("idle")
			#else:
				#$AnimatedSprite2D.play("moving")
			velocity.x = xdir * movement_speed
			velocity.y = ydir * movement_speed

			move_and_slide()


#func kill():
	#print(self, " killed.")
	#get_parent().remove_child(self)
	#$Sprite2D.hide()
	#$HitboxComponent.queue_free()
	#$CollisionShape2D.queue_free()
	#self.velocity = Vector2.ZERO

	#if self is Enemy:
		#get_parent().score += 5
	#if self is Player: get_parent().game_loss()
	#else:
	#if DeathParticles:
		#DeathParticles.emitting = true
		#await DeathParticles.finished
	#entity_death.emit( self )
	#queue_free()

#func swap_slots():
	#var new_weapon = secondary_slot
	#secondary_slot = equipped_weapon
	#equipped_weapon = new_weapon
	#secondary_slot.hide()
	#equipped_weapon.show()

func aim_item():
	var mouse_pos = get_global_mouse_position()
	var angle = rad_to_deg(get_angle_to(mouse_pos))
	equipped_item.rotation_degrees = angle
	#if angle >= 0:
	if angle < -90 or angle > 90:
		#self.scale.x = -1
		$Sprite2D.flip_h = false
	#if angle <= 0:
	else:
		#self.scale.x = 1
		$Sprite2D.flip_h = true


func equip_item(item):
	var old_item = equipped_item
	#old_item.hide()

	# Automatically use the new weapon
	var new_item = item
	#new_item.show()
	equipped_item = new_item
	new_item.use()
	item_used.emit(new_item)

	# Swap back to normal weapon
	equipped_item = old_item
