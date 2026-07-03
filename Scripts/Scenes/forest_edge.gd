@tool
extends Node2D

@export var forest_entrance_collider: Area2D
@export var walk_triggers: Array[WalkTrigger]
@export var moon: Control

func _ready() -> void:
	moon.scale.y = 0.0