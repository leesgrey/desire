extends Node

enum SoundType {AMBIENCE, SFX}

@export var stream_dict: Dictionary[String, CaptionedAudio]

@export var audio_caption_layer: CanvasLayer
@export var audio_caption_text: RichTextLabel

@export var ambience_players: Node
@export var sfx_players: Node

var _initial_footsteps_db: float

func _ready():
	SettingsManager.audio_caption_visibility_changed.connect(_on_audio_caption_visibility_changed)


func play_sound(sound, sound_type: SoundType, pitch_range: float = 0., fade_out: float = 0.):
	var audio_players: Array[Node]
	if (sound_type == SoundType.AMBIENCE):
		audio_players = ambience_players.get_children()
	elif (sound_type == SoundType.SFX):
		audio_players = sfx_players.get_children()
	for audio_player in audio_players:
		if not audio_player.playing:
			audio_player.volume_db = 0.
			if (fade_out > 0.):
				var tween = get_tree().create_tween()
				tween.tween_property(audio_player, "volume_db", -60, fade_out)
			audio_player.stream = stream_dict[sound].audio_stream
			if (pitch_range > 0.):
				audio_player.pitch_scale = randf_range(1. - pitch_range, 1. + pitch_range)
			audio_player.play()
			break


func show_audio_captions():
	audio_caption_layer.visible = true

func hide_audio_captions():
	audio_caption_layer.visible = false

func _on_audio_caption_visibility_changed(is_visible: bool):
	if (is_visible):
		show_audio_captions()
	else:
		hide_audio_captions()
