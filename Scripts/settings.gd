extends Control

@export var master_volume: HSlider
@export var ambient_volume: HSlider
@export var ambient_bus_name: String
@export var sfx_volume: HSlider
@export var sfx_bus_name: String


func _ready() -> void:
	_connect_slider(master_volume, "Master")
	_connect_slider(ambient_volume, "Ambience")
	_connect_slider(sfx_volume, "Sound")
	sfx_volume.drag_ended.connect(_on_drag_ended)
	master_volume.drag_ended.connect(_on_drag_ended)


func _connect_slider(h_slider, bus_name) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	h_slider.value_changed.connect(_on_value_changed.bind(bus_index))

	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))


func _on_value_changed(value: float, bus_index: int) -> void:
	print("_on_value_changed(" + str(value) + ", " + str(bus_index) + ")")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioManager.play_sound("bird", AudioManager.SoundType.SFX)
