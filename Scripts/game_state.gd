extends Node

signal writings_burnt
signal corpse_burnt
signal flowers_picked
signal axe_taken

@export var inventory: Dictionary[String, bool]
@export var choices: Dictionary[String, bool]
@export var seen_objects: Dictionary[String, bool]

var signal_dict: Dictionary = {
	"burn_writings": writings_burnt,
	"burn_corpse": corpse_burnt,
	"pick_flowers": flowers_picked,
	"take_axe": axe_taken
}


func record_action(key: String):
	print("record_action, key = " + key)
	if !key:
		return
	choices[key] = true
	if key in signal_dict:
		signal_dict[key].emit()


func reset():
	choices.clear()
	inventory.clear()
	seen_objects.clear()
