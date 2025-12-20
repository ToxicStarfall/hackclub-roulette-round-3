extends Node


@warning_ignore_start("unused_signal")
signal event_started(event: Event2)
signal event_ended(event: Event2)
signal event_changed(event: Event2)
#signal event_aborted(event: Event2)

signal dialogue_changed(dialogue_line: DialogueLine)
signal dialogue_progressed()
@warning_ignore_restore("unused_signal")

var event_history = []

var current_event: Event2
var current_dialogue: DialogueResource
var current_dialogue_line: DialogueLine

#var main_dialogue_path: String  ## The main dialogue path/title
#var current_dialogue_path: String  ## The current dialogue path/title

var event_data = {}

#var dialogue_idx: int = 0
#var dialogue_count: int = 0
#var dialogue_list: Array = []
#var dialogue_paths: Dictionary = {}
#var dialogue_paths = []



func _ready() -> void:
	#dialogue_changed.connect( _on_dialogue_changed )
	#dialogue_progressed.connect( _on_dialogue_progressed )
	#DialogueManager.passed_title.connect( _on_dialogue_mangager_title_passed )
	pass


func start_event(event_id: String = ""):
	#print("Event Started: %s" % [event.title])
	var event: Event2 = load("res://events/dialogue2/" + event_id + ".tres")
	var dialogue: DialogueResource = load("res://events/dialogue2/" + event_id + ".dialogue")
	if !event:
		push_error("Cannot find an event of id \"%s\". Event cancled." % [event_id])

		# Create a temproary event
		if dialogue:
			push_warning("Dialogue exists. Creating temproary event." % [event_id])
			event = Event2.new()
			#event.title = event_id.capitalize()
			var title = await dialogue.get_next_dialogue_line("title")
			if title: event.title = title.text
		#else:
		#return
	if !dialogue:
		push_error("Cannot find an event dialogue of id: %s. Event cancled." % [event_id])
		return

	current_event = event
	current_dialogue = dialogue
	get_next_dialogue_line("start")  # Retrieves the first dialogue line

	event_started.emit(current_event)


func end_event():
	event_ended.emit(current_event)
	current_event = null
	current_dialogue = null
	current_dialogue_line = null
	#main_dialogue_path = ""
	#current_dialogue_path = ""


func get_next_dialogue_line(next_dialogue_id: String = ""):
	var next_id = next_dialogue_id   # Dialogue redirect (if next_id given)
	if !current_dialogue_line: pass  # Beginning of dialogue check
	elif !next_id: next_id = current_dialogue_line.next_id  # Dialogue continue

	#print(next_id)
	var dialogue_line: DialogueLine
	#dialogue_line = await DialogueManager.get_next_dialogue_line(
	dialogue_line = await current_dialogue.get_next_dialogue_line(
			next_id,
			[Game, EventManager, Character])
	#print(dialogue_line)

	if dialogue_line:
		current_dialogue_line = dialogue_line
		dialogue_changed.emit(current_dialogue_line)
	else:
		print("no dialogue lines")
		end_event()

#func _on_dialogue_mangager_title_passed(title):
	## If a new event is here (prior event data cleared)
	#if !main_dialogue_path:
		#main_dialogue_path = title
		##print("new main dialogue path")
	##print(main_dialogue_path)
	##print(title)
	## Title is not the main dialogue title
	#if main_dialogue_path != title:
		## Title is not being repeated
		#if current_dialogue_path != title:
			#current_dialogue_path = title
			#get_next_dialogue_line(title)
			#pass


#func get_event(_location):
	# Apply modifiers to event
	#pass


#func load_random_event():
	#load_event( event_array[ randi_range(0, event_array.size() - 1) ])
	#start_event(current_event)


## Stores temproary event data (decisions, random values, etc)
func store(id: String, value: Variant) -> void:
	event_data.set(id, value)


## Returns specified stored event data
func retrieve(id) -> Variant:
	return event_data.get(id)


#func clear_data

func event_active() -> bool:
	if !current_event:
		return false
	else: return true
