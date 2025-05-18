extends Node2D

@export var play_button: Button
@export var quit_button: Button
@export var next_scene: String
@export var settings_button: Button
@export var settings_menu: Control
@export var main_menu: Control
@export var settings_back_button: Button
@export var audio_caption_checkbox: CheckBox
@export var buttons_container: VBoxContainer

@export var bird_sound_names: Array[String]


func _ready():
	play_button.pressed.connect(_start_game)
	quit_button.pressed.connect(_quit_game)
	settings_button.pressed.connect(_open_settings)
	settings_back_button.pressed.connect(_return_to_main_menu)
	audio_caption_checkbox.toggled.connect(_on_audio_caption_toggled)


func _start_game():
	main_menu.process_mode = Node.PROCESS_MODE_DISABLED
	AudioManager.play_sound("crow", AudioManager.SoundType.SFX, 0., 3.)
	Navigator.change_scene(next_scene, false, true, true)
	for button: Button in buttons_container.get_children():
		button.mouse_default_cursor_shape = Control.CURSOR_ARROW


func _quit_game():
	get_tree().quit()


func _open_settings():
	var bird_sound = bird_sound_names[randi_range(0, len(bird_sound_names) - 1)]
	AudioManager.play_sound(bird_sound, AudioManager.SoundType.SFX, 0.1, 2.)
	main_menu.visible = false
	settings_menu.visible = true


func _return_to_main_menu():
	settings_menu.visible = false
	main_menu.visible = true


func _on_audio_caption_toggled(toggled_on: bool):
	SettingsManager.set_audio_caption_visibility(toggled_on)
