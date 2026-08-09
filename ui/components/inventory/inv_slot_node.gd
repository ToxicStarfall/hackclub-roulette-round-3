class_name InvSlotNode
extends PanelContainer


@export var slot_type: String


func set_item(item: StringName, icon: Texture2D):
	%ItemIcon.texture = icon
	%NameLabel.text = item


func set_icon(icon: Texture2D):
	%ItemIcon.texture = icon
