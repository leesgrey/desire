class_name PathEntrance
extends Area2D

@export var destination: String
var seen: bool = false


func _enter_tree() -> void:
	seen = Navigator.is_path_seen(destination)


func _mouse_enter():
	if seen:
		TooltipHandler.show_tooltip(destination)


func _mouse_exit() -> void:
	TooltipHandler.hide_tooltip()


func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			Navigator.change_scene(destination)
