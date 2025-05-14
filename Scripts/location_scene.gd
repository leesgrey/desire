class_name LocationScene
extends Node

@export var starting_dialogue: DialogueEvent
@export var debug_force_start: bool = false


func _ready() -> void:
	DialogueManager.visible = true
	if (!Navigator.is_location_seen()):
		Navigator.scene_transition_end.connect(start_scene)
	if debug_force_start:
		start_scene()

func start_scene() -> void:
	if (starting_dialogue):
		DialogueManager.start_dialogue_event(starting_dialogue)
