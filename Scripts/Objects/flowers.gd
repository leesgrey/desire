extends Node

@export var flowers: PackedScene


func _ready() -> void:
	GameState.flowers_picked.connect(_on_flowers_picked)

	# if chest has been burnt, burning
	if "pick_flowers" not in GameState.choices:
		add_child(flowers.instantiate())


func _on_flowers_picked():
	get_child(0).queue_free()
	GameState.inventory["flowers"] = true
