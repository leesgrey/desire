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


func _ready():
	play_button.pressed.connect(_start_game)
	quit_button.pressed.connect(_quit_game)
	settings_button.pressed.connect(_open_settings)
	settings_back_button.pressed.connect(_return_to_main_menu)
	audio_caption_checkbox.toggled.connect(_on_audio_caption_toggled)
	play_button.mouse_entered.connect(_change_mouse_to_hand)
	play_button.mouse_exited.connect(_change_mouse_to_hand)


func _change_mouse_to_hand():
	print("wuh")
	Input.set_custom_mouse_cursor(null, Input.CursorShape.CURSOR_POINTING_HAND)


func _change_mouse_to_arrow():
	print("guh")
	Input.set_custom_mouse_cursor(null, Input.CursorShape.CURSOR_ARROW)


func _start_game():
	main_menu.process_mode = Node.PROCESS_MODE_DISABLED
	AudioManager.play_start_game_sound()
	Navigator.change_scene(next_scene, false, true)
	for button: Button in buttons_container.get_children():
		button.mouse_default_cursor_shape = Control.CURSOR_ARROW


func _quit_game():
	get_tree().quit()

func _open_settings():
	AudioManager.play_bird_sound()
	main_menu.visible = false
	settings_menu.visible = true

func _return_to_main_menu():
	settings_menu.visible = false
	main_menu.visible = true

func _on_audio_caption_toggled(toggled_on: bool):
	SettingsManager.set_audio_caption_visibility(toggled_on)
