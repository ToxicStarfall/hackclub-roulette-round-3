extends Node


@warning_ignore_start("unused_signal")
signal game_started
signal game_ended

signal intro_started
signal intro_ended

signal event_started (event: Event)
signal event_ended (event: Event)

signal action_started (action: Game.Action)
signal action_ended (action: Game.Action)
signal action_aborted (action: Game.Action)
