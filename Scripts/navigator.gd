extends Node

signal scene_transition_start
signal scene_transition_end

@export var animation_player: AnimationPlayer

var seen_locations: Array[LocationResource]
var next_scene: PackedScene


func _ready():
	animation_player.animation_finished.connect(on_animation_finished)


func change_scene(scene: PackedScene):
	animation_player.play("fade_in")
	next_scene = scene
	scene_transition_start.emit()


func on_animation_finished(animation_name: String):
	if animation_name == "fade_in":
		get_tree().change_scene_to_packed(next_scene)
		animation_player.play("fade_out")

	elif animation_name == "fade_out":
		scene_transition_end.emit()
