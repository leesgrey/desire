class_name TextTrigger
extends Area2D

@export var text: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node2D):
	SignalBus.update_narration.emit(text)
	monitoring = false
