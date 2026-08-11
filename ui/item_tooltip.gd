extends PanelContainer



func _ready() -> void:
	%CloseButton.pressed.connect( queue_free )


func set_item(item_id: StringName, _owned: int = 0):
	var item: ItemData = Registries.ITEMS.load_entry(item_id)
	%ItemIcon.texture = item.icon
	%ItemLabel.text = item.name
	%ItemDescription.text = item.description
	
