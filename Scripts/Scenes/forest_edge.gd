extends Node2D

@export var text_trigger_layers: Dictionary[String, Node2D]

var entered_from_left = !GameState.previous_location
var current_scene: TextScene

func _ready() -> void:
	print("forest_edge")
	print("entered from left: ", entered_from_left)

	if entered_from_left:  # Starting scene
		text_trigger_layers["start"].visible = true  # TODO: this doesnt work !!!!!!!!!!!!!
