extends Node

@export var footstep_player: AudioStreamPlayer
@export var audio_caption_layer: CanvasLayer
@export var audio_caption_text: RichTextLabel
@export var ui_sound_player: AudioStreamPlayer
@export var start_game_sound: AudioStream
@export var birds: Array[AudioStream]

var _initial_footsteps_db: float

func _ready():
	Navigator.scene_transition_start.connect(start_footsteps)
	Navigator.scene_transition_end.connect(stop_footsteps)
	SettingsManager.audio_caption_visibility_changed.connect(_on_audio_caption_visibility_changed)

	_initial_footsteps_db = footstep_player.volume_db


func start_footsteps():
	footstep_player.pitch_scale = randf_range(0.5, 1.5)
	footstep_player.play()
	set_audio_caption("footsteps on grass")

func stop_footsteps():
	var tween = get_tree().create_tween()
	tween.tween_property(footstep_player, "volume_db", -60, 0.5)
	tween.tween_callback(reset_footsteps)
	set_audio_caption("")

func reset_footsteps():
	footstep_player.stop()
	footstep_player.volume_db = _initial_footsteps_db

func show_audio_captions():
	audio_caption_layer.visible = true

func hide_audio_captions():
	audio_caption_layer.visible = false

func _on_audio_caption_visibility_changed(is_visible: bool):
	if (is_visible):
		show_audio_captions()
	else:
		hide_audio_captions()


func set_audio_caption(caption: String):
	audio_caption_text.text = caption

func play_start_game_sound():
	var original_db = ui_sound_player.volume_db
	var tween = get_tree().create_tween()
	tween.tween_property(ui_sound_player, "volume_db", -60, 5.)
	tween.tween_callback(reset_ui_sound.bind(original_db))
	ui_sound_player.pitch_scale = 1.
	ui_sound_player.stream = start_game_sound
	ui_sound_player.play()

func reset_ui_sound(original_db):
	ui_sound_player.stop()
	ui_sound_player.volume_db = original_db

func play_bird_sound():
	var tween = get_tree().create_tween()
	ui_sound_player.volume_db = 0.
	ui_sound_player.pitch_scale = randf_range(0.7, 1.3)
	tween.tween_property(ui_sound_player, "volume_db", -60, 2.)
	tween.tween_callback(reset_ui_sound.bind(0.))
	ui_sound_player.stream = birds[randi_range(0, len(birds) - 1)]
	print(ui_sound_player.stream)
	ui_sound_player.play()
