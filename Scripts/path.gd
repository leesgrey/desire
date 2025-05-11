class_name PathEntrance
extends Area2D

@export var path: PathResource


func _mouse_enter():
	if path.seen:
		print("show tooltip")


func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			print(path.left.get_state())
			#Navigator.change_scene(destination)
