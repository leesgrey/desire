extends Node2D

@export var WALK_SPEED: float = 40.
@export var pivot: Node2D
@export var animated_sprite: AnimatedSprite2D


func _unhandled_input(event: InputEvent) -> void:
	pass


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		position.x -= WALK_SPEED * delta
		pivot.scale.x = -1
		animated_sprite.play("walk")
	elif Input.is_action_pressed("move_right"):
		position.x += WALK_SPEED * delta
		pivot.scale.x = 1
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
