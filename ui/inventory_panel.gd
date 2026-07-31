extends Panel


@onready var tree: Tree = %Tree
@onready var root: TreeItem = tree.create_item()


func _ready() -> void:
	Game.inventory.changed.connect( update )

	tree.set_column_expand_ratio(0, 70)
	tree.set_column_expand_ratio(1, 30)
	for i in Items.new().keys():
		var item: TreeItem = tree.create_item(root)
		item.set_text(0, i)
		item.set_text(1, str(Game.inventory.get_item( i.to_upper() )))
	pass


func update():
	for i in Items.new().keys().size():
	#for i in root
		var child = root.get_child(i)
		child.set_text(1, str(Game.inventory.get_item( child.get_text(0) )))
		#print(root.get_children())
	pass
