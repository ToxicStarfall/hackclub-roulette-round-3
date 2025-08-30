extends Node


signal event_changed
signal event_started
signal event_ended
signal event_aborted

signal dialogue_changed(new_dialogue)
signal dialogue_requested()

var current_event: Event
var current_dialogue: Dialogue
#var event
var dialogue_idx: int = 0
var dialogue_count: int = 0
var dialogue_list: Array = []
#var dialogue_paths: Dictionary = {}
var dialogue_paths = []

var event_history = []

var event_array = [
	"res://events/dialogues/animal_attack.tres",
	"res://events/dialogues/bandits.tres",
	"res://events/dialogues/desert_winds.tres",
	"res://events/dialogues/guards.tres",
	"res://events/dialogues/the_beggar.tres",
	"res://events/dialogues/village.tres",
]


func _ready() -> void:
	#dialogue_changed.connect( _on_dialogue_changed )
	dialogue_requested.connect( _on_dialogue_requested )
	load_event("res://events/dialogues/new_journey.tres")
	#load_event("res://events/dialogues/village.tres")


func get_event(location):
	# Apply modifiers to event
	pass

func load_random_event():
	load_event( event_array[ randi_range(0, event_array.size() - 1) ])
	#start_event(current_event)


func start_event(event):
	print("Event Started: %s" % [event.title])
	event_started.emit(event)
	event_changed.emit(event)
	dialogue_changed.emit( get_first_dialogue() )


func end_event():
	event_ended.emit(current_event)
	current_event = null


func get_dialogue(path: String = ""):
	var new_dialogue
	if path:
		# Return to main dialogue branch
		if path == "^":
			new_dialogue = get_next_dialogue()
		# Go to a side/alternate dialogue branch.
		else:
			new_dialogue =  get_path_dialogue(path)
		current_dialogue = new_dialogue
		return new_dialogue
	# Get the next dialogue in the main branch.
	else: return get_next_dialogue()


func get_next_dialogue():
	print(dialogue_idx)
	dialogue_idx += 1
	if dialogue_list.size() -1  >= dialogue_idx:
	#if dialogue_list[dialogue_idx]:
		var dialogue = dialogue_list[dialogue_idx]
		#if dialogue.has("options"):
		if dialogue.get("options"):
			for option in dialogue.options:
				#print(option.name)
				pass
		return dialogue
	else: end_event()


func get_first_dialogue():
	var first_dialogue = dialogue_list[0]
	current_dialogue = first_dialogue
	return first_dialogue


func get_path_dialogue(path: String):
	var dialogue = dialogue_paths[int(path)]
	return dialogue


#func _on_dialogue_changed(new_dialogue):
	#current_dialogue = new_dialogue
	#print("new dialogue set")


func _on_dialogue_requested(dialogue_path: String = "", alt_dialogue: Dialogue = null):
	if alt_dialogue:
		current_dialogue = alt_dialogue
		dialogue_changed.emit( alt_dialogue )
	else:
		var a = get_dialogue(dialogue_path)
		if a:
			dialogue_changed.emit( a )


func load_event(event_res):
	#var jstr = FileAccess.open("res://events/new_journey.json", FileAccess.READ).get_as_text()
	#var obj = JSON.parse_string(jstr)
	#var obj = load("res://events/dialogues/new_journey.tres")
	var obj = load(event_res)
	#event = obj
	current_event = obj
	dialogue_idx = 0
	dialogue_list = obj.dialogue
	dialogue_paths = obj.paths
	dialogue_count = dialogue_list.size()
	start_event(current_event)
	#for key in event_obj:
