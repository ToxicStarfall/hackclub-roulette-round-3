extends PanelContainer




func _ready():
	%TabBar.tab_changed.connect( func(tab): %TabContainer.current_tab = tab )
	pass
