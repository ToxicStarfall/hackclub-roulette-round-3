extends PanelContainer



var linked_inventory: InventoryComponent

@onready var tree: Tree = %Tree
@onready var root: TreeItem = tree.create_item()



func _ready():
	Game.inventory.changed.connect( update )
	%TabBar.tab_changed.connect( func(tab): %TabContainer.current_tab = tab )

	position.x = get_parent().position.x
	position.y -= self.size.y
	
	tree.set_column_expand(0, true)
	tree.set_column_expand(1, true)
	tree.set_column_expand_ratio(0, 8)
	tree.set_column_expand_ratio(1, 2)
	
	#var items = Registries.ITEMS.load_all_blocking()
	#for id in items:
		#tree.create_item(root)
			

func update():
	_clear_tree()
		
	var items = Registries.ITEMS.load_all_blocking()
	#var idx = 0
	
	for id in items:
		#print(id)
		#print(Game.inventory.has(id))
		if Game.inventory.has(id):
			var item = items.get(id)
			var quantity = Game.inventory.get_item( id )
			
			if quantity > 0:
				var tree_item: TreeItem = tree.create_item(root)
				tree_item.set_text(0, item.name)
				tree_item.set_text(1, str(quantity))
			#else:
				#var tree_item = root.get_child(idx)
				#root.remove_child(tree_item)
		#idx += 1
	pass


func _clear_tree():
	for tree_item in root.get_children():
		root.remove_child(tree_item)
