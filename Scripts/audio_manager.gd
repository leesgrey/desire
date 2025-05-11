extends Node

@export var footstep_player: AudioStreamPlayer

var _initial_footsteps_db: float

func _ready():
	Navigator.scene_transition_start.connect(start_footsteps)
	Navigator.scene_transition_end.connect(stop_footsteps)

	_initial_footsteps_db = footstep_player.volume_db


func start_footsteps():
	footstep_player.pitch_scale = randf_range(0.5, 1.5)
	footstep_player.play()

func stop_footsteps():
	var tween = get_tree().create_tween()
	tween.tween_property(footstep_player, "volume_db", -60, 0.5)
	tween.tween_callback(reset_footsteps)

func reset_footsteps():
	print("resetting footsteps")
	footstep_player.stop()
	footstep_player.volume_db = _initial_footsteps_db
