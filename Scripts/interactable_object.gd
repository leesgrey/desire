class_name InteractableObject
extends Area2D

@export var dialogue_event: DialogueEvent
@export var label: String
@export var always_show_label: bool = false
@export var id: String

var seen = false


func _enter_tree() -> void:
	seen = id in GameState.seen_objects
	pass


func _mouse_enter():
	if always_show_label or seen:
		TooltipHandler.show_tooltip(label)
	else:
		TooltipHandler.show_tooltip("?")


func _mouse_exit() -> void:
	TooltipHandler.hide_tooltip()


func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			_on_click()
			GameState.seen_objects[id] = true
			seen = true


func _on_click():
	DialogueManager.start_dialogue_event(dialogue_event)
	# implement in inheriting objects
	pass
