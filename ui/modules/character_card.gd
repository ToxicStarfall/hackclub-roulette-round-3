extends Control


var character: Character


func _ready() -> void:
	pass


func _on_character_stat_changed():
	update()


func set_character(new_character: Character):
	character = new_character
	character.stat_changed.connect( _on_character_stat_changed)
	%NameLabel.text = character.info.name
	update()


func update():
	%HungerBar.value = Game.player.stats.get("hunger")
	%HealthBar.value = Game.player.stats.get("health")
	%HungerBar/Label.text = "%s / %s" % [snapped(Game.player.stats.get("hunger"), 0.1), snapped(Game.player.stats.get("max_hunger"), 1)]
	%HealthBar/Label.text = "%s / %s" % [snapped(Game.player.stats.get("health"), 0.1), snapped(Game.player.stats.get("max_health"), 1),]
	
	if Game.player.stats.get("health") < Game.player.stats.get("health") * 0.7:
		#%ProfileIcon.texture = load("res://ui/icons/profile_hurt.png")
		%ProfileIcon.texture = load("res://profile_new.svg")
	else:
		#%ProfileIcon.texture = load("res://ui/icons/profile_normal.png")
		%ProfileIcon.texture = load("res://profile_new.svg")
