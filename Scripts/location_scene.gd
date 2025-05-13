class_name LocationScene
extends Node

@export var locationResource: LocationResource
@export var starting_dialogue: DialogueEvent
@export var dialogue_box: DialogueBox


func _ready() -> void:
	Navigator.scene_transition_end.connect(start_scene)


func start_scene() -> void:
	dialogue_box.start_dialogue_event(starting_dialogue)
