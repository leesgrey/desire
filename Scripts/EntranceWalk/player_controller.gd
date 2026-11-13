extends CharacterBody2D

@export var WALK_SPEED: float = 40.
@export var pivot: Node2D
@export var animated_sprite: AnimatedSprite2D
@export var visibility_notifier: VisibleOnScreenNotifier2D


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		velocity = Vector2(WALK_SPEED * -delta, 0)
		pivot.scale.x = -1
		animated_sprite.play("walk")
	elif Input.is_action_pressed("move_right"):
		velocity = Vector2(WALK_SPEED * delta, 0)
		pivot.scale.x = 1
		animated_sprite.play("walk")
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
	
	move_and_slide()
	
	
