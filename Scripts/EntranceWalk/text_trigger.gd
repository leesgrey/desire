class_name TextTrigger
extends Area2D

@export var text: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	print(text)
