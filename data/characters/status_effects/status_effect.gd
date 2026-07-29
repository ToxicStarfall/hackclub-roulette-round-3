class_name StatusEffect
extends Resource


@export var icon: Texture2D
@export var name: String
@export_multiline() var description: String
@export var duration: float  ## Duration in in-game hours. -1 = infinite.
#@export var effects: Array
@export var levels: Array[StatusEffectLevel]
