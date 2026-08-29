extends PanelContainer


signal option_selected(option: String)

var item: StringName

@onready var tree: Tree = %Tree
@onready var root: TreeItem = tree.create_item()


func _ready() -> void:
	tree.set_column_expand(0, true)
	%ItemList.item_clicked.connect( _on_item_clicked )


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not Rect2(Vector2(), size).has_point( get_local_mouse_position() ):
			UI.clear_popups()
			


func _on_item_clicked(index: int, _at_position: Vector2, mouse_button_index: int):
	if mouse_button_index == 1:
		option_selected.emit( %ItemList.get_item_text(index), item )
	elif mouse_button_index == 2:
		UI.clear_popups()
	UI.clear_popups()


func set_options(options: Array):
	for option in options:
		#var button = Button.new()
		#button.text = option
		#%OptionsContainer.add_child(button)
		%ItemList.add_item(option.capitalize())
