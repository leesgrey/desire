extends Node

@export var corner_text: RichTextLabel
@export var text_delay: float

var timer: float = 0.


func _process(delta: float) -> void:
	if corner_text.visible:
		return

	timer += delta
	if timer >= text_delay:
		corner_text.visible = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			Navigator.restart_game()
