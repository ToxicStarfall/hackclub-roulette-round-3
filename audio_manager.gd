extends Node2D


const AUDIO_PATH = "res://assets/audio/"

const AUDIO_PLAYER_ENABLED: bool = true
const AUDIO_PLAYER_2D_ENABLED: bool = false
#const AUDIO_PLAYER_3D_ENABLED: bool = false

const MAX_AUDIO_PLAYER: int = 5
const MAX_AUDIO_PLAYER_2D: int = 10
#const MAX_AUDIO_PLAYER_3D: int = 10


var streams: Array[AudioStream]
var players: Array[AudioStreamPlayer]
var players_2d: Array[AudioStreamPlayer2D]
#var queue

var temp: int = 0
var temp_2d: int = 0



func _ready() -> void:
	Events.audio_requested.connect( _on_audio_requested )
	#Events.audio_2d_requested.connect( _on_audio_2d_requested )
	
	if AUDIO_PLAYER_ENABLED:
		for i in MAX_AUDIO_PLAYER:
			_create_player()
	if AUDIO_PLAYER_2D_ENABLED:
		for i in MAX_AUDIO_PLAYER_2D:
			_create_player_2d()
	#if AUDIO_PLAYER_3D_ENABLED:
		#for i in MAX_AUDIO_PLAYER_3D:
			#_create_player_3d()



func _on_audio_requested(stream: AudioStream, bus: StringName = &"Master"):
	if stream:
		var player: AudioStreamPlayer = players.pop_front()
		if !player:  # Add new temproary player
			player = _create_player()
			temp += 1
		
		player.bus = bus
		player.stream = stream
		player.play()
		await player.finished
		if temp > 1:
			temp -= 1
			player.queue_free()
		else:
			players.append(player)


#func _on_audio_2d_requested(stream: AudioStream, audio_position: Vector2 = Vector2.ZERO):
	#if stream:
		#var player = players_2d.pop_front()
		#if !player:  # Add new temproary player
			#player = _create_player_2d()
			#temp_2d += 1
		#
		#player.global_position = audio_position
		#player.stream = stream
		#player.play()
		#await player.finished
		#if temp_2d > 1:
			#temp_2d -= 1
			#player.queue_free()
		#else:
			#players_2d.append(player)

		
	
func find(audio_id: String) -> AudioStream:
	var file_type = [".mp3", ".wav", ".ogg"]
	for i in file_type:
		if ResourceLoader.exists(AUDIO_PATH + audio_id + i):
			return ResourceLoader.load(AUDIO_PATH + audio_id + i)
	return null


func _create_player():
	var new_player = AudioStreamPlayer.new()
	new_player.max_polyphony = 3
	new_player.bus = "UI"
	players.append(new_player)
	add_child(new_player)
	return new_player


func _create_player_2d():
	var new_player_2d = AudioStreamPlayer2D.new()
	new_player_2d.max_polyphony = 5
	new_player_2d.bus = "SFX"
	players_2d.append(new_player_2d)
	add_child(new_player_2d)
	return new_player_2d
