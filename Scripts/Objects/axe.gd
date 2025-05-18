extends Node

@export var axe: PackedScene


func _ready() -> void:
	GameState.axe_taken.connect(_on_axe_taken)

	if "take_axe" not in GameState.choices:
		add_child(axe.instantiate())


func _on_axe_taken():
	get_child(0).queue_free()
	GameState.inventory["axe"] = true
