extends Node


@warning_ignore_start("unused_signal")
signal event_started(event: Event2)
signal event_ended(event: Event2)
signal event_changed(event: Event2)
#signal event_aborted(event: Event2)

signal input_requested(prompt: String, save_id: String, default: String)

signal dialogue_changed(dialogue_line: DialogueLine)
signal dialogue_progressed()
@warning_ignore_restore("unused_signal")


const DIALOGUE_PATH = "res://events/dialogue2/"
const dialogues = [
	"animal_attack",
	"bandits", "beggar",
	"desert_winds",
	"guards",
	"meadows",
	"village",
	"waters_path"
]

var dialogue_globals = [Game, EventManager, Character, Items]

var event_history: Array = []
var event_queue: Array = []

#var current_event_id: String
var current_event: Event2
var current_dialogue: DialogueResource
var current_dialogue_line: DialogueLine

## Temproary data storage used to save temproary dialogue results.
var temp = {}



func _ready() -> void:
	#DialogueManager.passed_title.connect( _on_dialogue_mangager_title_passed )
	pass


func start_event(event_id: String = ""):
	# If an event is currently active, add to queue
	if current_event:
		event_queue.append(event_id)
		return

	#print("Event Started: %s" % [event.title])
	var event_path = "res://events/dialogue2/" + event_id + ".tres"
	var dialogue_path = "res://events/dialogue2/" + event_id + ".dialogue"
	var event: Event2
	var dialogue: DialogueResource

	if ResourceLoader.exists(event_path):
		event = load(event_path)
	else: pass
	if ResourceLoader.exists(dialogue_path):
		dialogue = load(dialogue_path)
	else: pass

	if !event:
		#push_error("[game] Cannot find an event of id \"%s\"." % [event_id])
		# Create a temproary event
		if dialogue:
			push_warning("[game] Dialogue exists. Creating temproary event.")
			event = Event2.new()
			var title = await dialogue.get_next_dialogue_line("title")
			if title: event.title = title.text  # Use the declared title within the dialogue.
			else: event.title = event_id.capitalize()  # Fallback to event id.
		# Cancel event if not available
		else:
			push_warning("No fallback dialogue. Cancelling event.")
			return
	if !dialogue:
		push_error("Cannot find an event dialogue of id: %s. Event cancled." % [event_id])
		return

	current_event = event
	current_event.id = event_id
	current_dialogue = dialogue
	get_next_dialogue_line("start")  # Retrieves the first dialogue line

	event_started.emit(current_event)


func start_event_random(_group: String = ""):
	start_event( dialogues.get(randi_range(0, dialogues.size() - 1)) )


func end_event():
	event_ended.emit(current_event)
	event_history.append(current_event)

	current_event = null
	current_dialogue = null
	current_dialogue_line = null
	clear_temp()  # Clear temproary event data

	#if event_queue.is_empty():
		#if event_history[-1].id == "common/night":
			#Game.pause()
			#await Game.World.light_to_dark()
			#await get_tree().create_timer(1.0).timeout
			#await Game.World.dark_to_light()
			#EventManager.start_event("common/morning")
	#else:
		#if event_history[-1].id == "common/night":
			#event_queue.append("common/morning")
		#Game.pause()
		#await Game.World.light_to_dark()
		#await get_tree().create_timer(1.0).timeout
		#await Game.World.dark_to_light()
		#start_event( event_queue.pop_front() )


func restart_event():
	var event_id = current_event.id
	end_event()
	start_event(event_id)


func get_next_dialogue_line(next_dialogue_id: String = ""):
	var next_id = next_dialogue_id   # Dialogue redirect (if next_id given)
	if !current_dialogue_line: pass  # Beginning of dialogue check
	elif !next_id: next_id = current_dialogue_line.next_id  # Dialogue continue

	#print(next_id)
	var dialogue_line: DialogueLine
	#dialogue_line = await DialogueManager.get_next_dialogue_line(
	dialogue_line = await current_dialogue.get_next_dialogue_line(
			next_id,
			dialogue_globals
	)
	#print(dialogue_line)

	if dialogue_line:
		current_dialogue_line = dialogue_line
		dialogue_changed.emit(current_dialogue_line)
	else:
		print("no dialogue lines")
		end_event()


#func _on_dialogue_mangager_title_passed(title):
	#pass

#func get_event(_location):
	# Apply modifiers to event
	#pass


func event_active() -> bool:
	if !current_event:
		return false
	else: return true

#
func request_input(prompt: String, save_id: String, default: Variant = null):
	input_requested.emit(prompt, save_id, default)


## Stores temproary event data (decisions, random values, etc)
func store(id: String, value: Variant) -> void:
	temp.set(id, value)
	print(id + " ", value)


## Returns the specified event data
func retrieve(id, default = null) -> Variant:
	var result: Variant = temp.get(id, default)
	if result:  return temp.get(id)
	else:
		push_error("[EventManager]: Could not get temproary data of id: \"%s\"." % [id])
		return result


## Clears temproary event data
func clear_temp():
	temp.clear()


# Dialogue utility functions

func chance(part: float, whole: float) -> bool:
	return part > randf() * whole


#func rand_item(items: Array[Items]):
	#pass

# Returns random phrase out of an array of phrases
func rand_phrase(phrases: Array[String], weights: Array[float] = [], _as_int: bool = false) -> Dictionary:
	if weights.is_empty():
		weights.resize( phrases.size() )
		weights.fill( 1.0 )
	var result = {}
	result.set("phrase", phrases.pick_random())
	result.set("index", phrases.find( result.phrase ))
	#if _as_int: return phrases.find( phrases.pick_random() )  # Returns as int
	#else: return phrases.pick_random()  # Returns as string
	return result


#func rand_phrase_as_int(phrases: Array[String]) -> int:
	#return rand_phrase(phrases, true)


func d_randf_range(from: float, to: float) -> float:
	return randf_range(from, to)

func d_randi_range(from: int, to: int) -> int:
	return randi_range(from, to)

func d_print(what: Variant) -> void:
	print("[EventManager] - ", what)
