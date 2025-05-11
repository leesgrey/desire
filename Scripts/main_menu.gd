extends Node2D

@export var play_button: Button
@export var quit_button: Button
@export var next_scene: PackedScene


func _ready():
	play_button.pressed.connect(_start_game)
	quit_button.pressed.connect(_quit_game)


func _start_game():
	Navigator.change_scene(next_scene)


func _quit_game():
	get_tree().quit()
