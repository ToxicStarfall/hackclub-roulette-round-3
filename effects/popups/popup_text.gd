class_name PopupText
extends Label


var velocity: Vector2 = Vector2(0, -50)
var tilt = 0


#func _setup():
	#self.add_theme_font_size_override())


func _init(initial_position: Vector2, popup_text, icon: Texture2D) -> void:
	#_setup()
	self.position = initial_position
	self.text += "[img]%s[/img]" % [icon]
	self.text += str(popup_text)


func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	#velocity.y -= delta
	self.position += velocity * delta
