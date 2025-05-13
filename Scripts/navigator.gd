extends Node

signal scene_transition_start
signal scene_transition_end

@export var animation_player: AnimationPlayer
@export var location_dict: Dictionary[String, PackedScene]
@export var ending_scene: PackedScene
@export var main_menu: PackedScene

var current_scene: String
var next_scene: String
var seen_paths: Array[Path]

var ending_num: int


func _ready():
	animation_player.animation_finished.connect(on_animation_finished)


func change_scene(scene: String, is_path: bool = true, slow: bool = false, force_footsteps: bool = false):
	if slow:
		animation_player.play("fade_in_slow")
	else:
		animation_player.play("fade_in")
	next_scene = scene
	if is_path or force_footsteps:
		AudioManager.play_sound("footsteps_grass", AudioManager.SoundType.SFX, 0.5, 5.)
	if is_path and !is_path_seen:
		var new_path = Path.new()
		new_path.left = current_scene
		new_path.right = next_scene
		seen_paths.append(new_path)
	scene_transition_start.emit()


func is_path_seen(destination: String, origin: String = current_scene) -> bool:
	for path in seen_paths:
		if path.left == origin and path.right == destination:
			return true
		elif path.right == origin and path.left == destination:
			return true
	return false


func go_to_ending():
	animation_player.play("fade_in_ending")
	scene_transition_start.emit()


func on_animation_finished(animation_name: String):
	if animation_name == "fade_in_ending":
		get_tree().change_scene_to_packed(ending_scene)
		animation_player.play("fade_out")
	
	elif animation_name == "fade_in_main_menu":
		get_tree().change_scene_to_packed(main_menu)
		animation_player.play("fade_out")

	elif animation_name == "fade_in" || animation_name == "fade_in_slow":
		get_tree().change_scene_to_packed(location_dict[next_scene])
		current_scene = next_scene
		animation_player.play("fade_out")

	elif animation_name == "fade_out":
		scene_transition_end.emit()


func restart_game():
	animation_player.play("fade_in_main_menu")
	scene_transition_start.emit()
