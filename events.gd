extends Node


@warning_ignore_start("unused_signal")
signal game_started
signal game_ended

signal tick_changed (tick: int)
signal day_changed (day: int)
signal distance_changed (distance: float)
signal location_changed (location: Region)

signal action_started (action: Game.Action)
signal action_ended (action: Game.Action)
signal action_aborted (action: Game.Action)

signal event_started (event: Event)
signal event_ended (event: Event)
