extends Node

signal audio_caption_visibility_changed(is_visible: bool)

var settings: Settings


func _ready():
	settings = Settings.new()


func set_audio_caption_visibility(is_visible: bool):
	settings.audio_captions = is_visible
	audio_caption_visibility_changed.emit(is_visible)
