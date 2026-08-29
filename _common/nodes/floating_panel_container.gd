class_name FloatingPanelContainer
extends PanelContainer


@export var handle_size: float = 2.0
@export var draggable: bool = true
@export var resizeable: bool = true
@export var limit_to_screen_bounds: bool = true

var dragging: bool = false
var drag_offset: Vector2


func _ready() -> void:
	pass


#func _input(event: InputEvent) -> void:
func _unhandled_input(event: InputEvent) -> void:
	# TODO - Fix input not propagating to both CloseButton and drag input.
	
	if event is InputEventMouse:
		if dragging:
			global_position = get_global_mouse_position() - drag_offset
			
	#if event is InputEventMouseButton:
		if Rect2( Vector2(), size).has_point( get_local_mouse_position() ):
			if !Rect2( Vector2.ONE * handle_size, size - Vector2.ONE * (handle_size * 2)).has_point( get_local_mouse_position() ):
				mouse_default_cursor_shape = Control.CURSOR_HSIZE
				# TODO - Resizing code
			else:
				mouse_default_cursor_shape = Control.CURSOR_ARROW
				
				if draggable:
					if event is InputEventMouseButton:
						if event.pressed:
							dragging = true
							drag_offset = get_local_mouse_position()
							mouse_default_cursor_shape = Control.CURSOR_DRAG
						else:
							dragging = false
							mouse_default_cursor_shape = Control.CURSOR_ARROW
						move_to_front()
