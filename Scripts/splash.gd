extends Node2D

@export var main_menu: PackedScene
@export var blackout: ColorRect
@export var max_blackout_time: float
@export var max_show_time: float

var time_shown: float = 0.
var blackout_time: float = 0.


func _ready() -> void:
	AudioManager.play_sound("forest_ambience", AudioManager.SoundType.AMBIENCE)


func _process(delta: float) -> void:
	if blackout.visible:
		blackout_time += delta

		if blackout_time >= max_blackout_time:
			get_tree().change_scene_to_packed(main_menu)

	else:
		time_shown += delta

		if time_shown >= max_show_time:
			blackout.visible = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or !blackout.visible:
		if Input.is_action_just_pressed("click"):
			blackout.visible = true
