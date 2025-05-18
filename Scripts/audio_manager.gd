extends Node

enum SoundType { AMBIENCE, SFX }

@export var stream_dict: Dictionary[String, CaptionedAudio]

@export var audio_caption_layer: CanvasLayer
@export var audio_caption_text: RichTextLabel

@export var ambience_players: Node
@export var sfx_players: Node

@export var sound_captions: VBoxContainer

var player_tracker: Dictionary[int, PanelContainer]


func _ready():
	SettingsManager.audio_caption_visibility_changed.connect(_on_audio_caption_visibility_changed)

	for audio_player in ambience_players.get_children():
		audio_player.finished.connect(_on_sound_finished.bind(audio_player.get_instance_id()))

	for audio_player in sfx_players.get_children():
		audio_player.finished.connect(_on_sound_finished.bind(audio_player.get_instance_id()))


func play_sound(sound, sound_type: SoundType, pitch_range: float = 0., fade_out: float = 0.):
	var audio_players: Array[Node]
	if sound_type == SoundType.AMBIENCE:
		audio_players = ambience_players.get_children()
	elif sound_type == SoundType.SFX:
		audio_players = sfx_players.get_children()
	for audio_player in audio_players:
		if not audio_player.playing:
			audio_player.volume_db = 0.
			if fade_out > 0.:
				var tween = get_tree().create_tween()
				tween.tween_property(audio_player, "volume_db", -60, fade_out)
				tween.finished.connect(_on_sound_finished.bind(audio_player.get_instance_id()))
			audio_player.stream = stream_dict[sound].audio_stream
			if pitch_range > 0.:
				audio_player.pitch_scale = randf_range(1. - pitch_range, 1. + pitch_range)
			audio_player.play()
			add_to_sound_captions(audio_player.get_instance_id(), stream_dict[sound].caption)
			return audio_player


func add_to_sound_captions(audio_player_id: int, caption: String):
	var new_sound_caption = PanelContainer.new()
	new_sound_caption.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	new_sound_caption.theme_type_variation = "AudioCaption"
	var new_sound_caption_text = RichTextLabel.new()
	new_sound_caption_text.theme_type_variation = "SubtitleText"
	new_sound_caption_text.fit_content = true
	new_sound_caption_text.autowrap_mode = false
	new_sound_caption_text.text = caption

	player_tracker[audio_player_id] = new_sound_caption

	new_sound_caption.add_child(new_sound_caption_text)
	sound_captions.add_child(new_sound_caption)
	sound_captions.move_child(new_sound_caption, 0)


func _on_sound_finished(player_id: int):
	if player_id in player_tracker and player_tracker[player_id] != null:
		player_tracker[player_id].queue_free()


func show_audio_captions():
	audio_caption_layer.visible = true


func hide_audio_captions():
	audio_caption_layer.visible = false


func _on_audio_caption_visibility_changed(is_visible: bool):
	if is_visible:
		show_audio_captions()
	else:
		hide_audio_captions()


func fade_out_player(player: AudioStreamPlayer, time: float):
	var tween = get_tree().create_tween()
	tween.tween_property(player, "volume_db", -60, time)


func stop(player: AudioStreamPlayer):
	player.stop()
	_on_sound_finished(player.get_instance_id())
