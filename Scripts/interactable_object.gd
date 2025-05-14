class_name InteractableObject
extends Area2D

@export var dialogue_event: DialogueEvent
@export var label: String
var seen: bool = false


func _enter_tree() -> void:
	#seen = Navigator.is_path_seen(destination)
  pass


func _mouse_enter():
	if seen:
		TooltipHandler.show_tooltip(label)


func _mouse_exit() -> void:
	TooltipHandler.hide_tooltip()


func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
      print("interactable object clicked")
