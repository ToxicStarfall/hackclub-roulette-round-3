extends Node


@warning_ignore_start("unused_signal")
signal event_started(event: Event2)
signal event_ended(event: Event2)
signal event_changed(event: Event2)
signal event_aborted(event: Event2)

signal dialogue_changed(dialogue_line: DialogueLine)
signal dialogue_progressed()
@warning_ignore_restore("unused_signal")

var current_event: Event2
var current_dialogue: DialogueResource
var current_dialogue_line: DialogueLine

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
	#dialogue_progressed.connect( _on_dialogue_progressed )

	#load_event("res://events/dialogues/new_journey.tres")
	#load_event("res://events/dialogues/village.tres")
	pass


func start_event(event_id):
	#print("Event Started: %s" % [event.title])
	#event_changed.emit(event)
	var event: Event2 = load("res://events/dialogue2/" + event_id + ".tres")
	var dialogue: DialogueResource = event.dialogue
	current_event = event
	current_dialogue = dialogue
	get_next_dialogue_line()  # Retrieves the first dialogue line

	event_started.emit(current_event)


func end_event():
	event_ended.emit(current_event)
	current_event = null
	current_dialogue = null
	current_dialogue_line = null


func get_next_dialogue_line(next_dialogue_id: String = ""):
	var next_id = next_dialogue_id   # Dialogue redirect (if next_id given)
	if !current_dialogue_line: pass  # Beginning of dialogue check
	elif !next_id: next_id = current_dialogue_line.next_id  # Dialogue continue

	var dialogue_line: DialogueLine
	dialogue_line = await DialogueManager.get_next_dialogue_line(
			current_dialogue,
			next_id,
			[Game, EventManager, Character])
	if dialogue_line:
		#print(dialogue_line)
		current_dialogue_line = dialogue_line
		dialogue_changed.emit(current_dialogue_line)
	else:
		#event_ended.emit()
		pass


#func get_event(_location):
	# Apply modifiers to event
	#pass


#func load_random_event():
	#load_event( event_array[ randi_range(0, event_array.size() - 1) ])
	#start_event(current_event)


#func get_dialogue(path: String = ""):
	#var new_dialogue
	#if path:
		## Return to main dialogue branch
		#if path == "^":
			#new_dialogue = get_next_dialogue()
		## Go to a side/alternate dialogue branch.
		#else:
			#new_dialogue =  get_path_dialogue(path)
		#current_dialogue = new_dialogue
		#return new_dialogue
	## Get the next dialogue in the main branch.
	#else: return get_next_dialogue()


#func get_next_dialogue():
	#print(dialogue_idx)
	#dialogue_idx += 1
	#if dialogue_list.size() -1  >= dialogue_idx:
	##if dialogue_list[dialogue_idx]:
		#var dialogue = dialogue_list[dialogue_idx]
		##if dialogue.has("options"):
		#if dialogue.get("options"):
			#for option in dialogue.options:
				##print(option.name)
				#pass
		#return dialogue
	#else: end_event()


#func get_first_dialogue():
	#var first_dialogue = dialogue_list[0]
	#current_dialogue = first_dialogue
	#return first_dialogue


#func get_path_dialogue(path: String):
	#var dialogue = dialogue_paths[int(path)]
	#return dialogue


#func _on_dialogue_changed(new_dialogue):
	#current_dialogue = new_dialogue
	#print("new dialogue set")


#func load_event(_event_id):
	#var obj = load(event_res)
	#current_event = obj
	#dialogue_idx = 0
	#dialogue_list = obj.dialogue
	#dialogue_paths = obj.paths
	#dialogue_count = dialogue_list.size()
	#start_event(current_event)

	#var event: Event2 = load("res://events/dialogue2/" + event_id + ".tres")
	#var dialogue: DialogueResource = event.dialogue
	#var dialogue_line: DialogueLine = await DialogueManager.get_next_dialogue_line(dialogue)
	#current_event = event
	#current_dialogue = dialogue
	#current_dialogue_line = dialogue_line

	#start_event(event)
	#pass
