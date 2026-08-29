class_name ItemData
extends Resource


enum Tags { NONE, ONE_HANDED, TWO_HANDED, CURRENCY, MATERIAL, SWORD, AXE, KNIFE, BOW, SHIELD, FOOD, HEALING, BODY_PART }
#enum Quality { NORMAL, DAMAGED, WORN, REINFORCED, HIGH_QUALITY, ORNATE }
#enum WeaponType { GENERIC, SWORD, SPEAR, AXE, KNIFE, BOW, CROSSBOW, SHIELD }
enum SlotType { NONE, PRIMARY, SECONDARY, TERTIARY, HEAD, BODY, ARMS, LEGS, HANDS, FEET, NECK, BELT, WRIST, ANKLE, BACK }


#@warning_ignore_start("unused_signal")
#signal item_used
#signal item_equipped
#signal item_unequipped


@export var enabled: bool = true  ## If false, this item will be hidden and unavailable.

@export var icon: Texture2D
@export var name: String = ""
@export_multiline var description: String = ""
@export var weight: float = 1.0  ## Weight in kg.
@export var value: float = 1.0  ## Value in gold coins (for selling).
@export var stack: int = 1  ## Maximum stack size of this item.
@export_range(0,3) var tier: int = 0  ## 
@export var tags: Array[Tags]  ## 
#@export var tags2: Array[StringName]
#@export var tags3: Array[Tag]  ## 

#@export_enum("None", "Primary", "Secondary", "Tertiary", "Head", "Body", "Arms", "Legs", "Hands", "Feet")
#var slot_type: String = "None"
@export var slot_type: SlotType = SlotType.NONE


func _init() -> void:
	if !icon:
		icon = preload("res://icon.svg")


#func get_text() -> String:
	#var text: String
	#
	#return text
