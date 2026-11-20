extends CharacterBody2D

@export var WALK_SPEED: float = 40.
@export var RUN_SPEED: float = 80.
@export var animated_sprite: AnimatedSprite2D

var triggered := false

func _ready() -> void:
    visible = false

func _physics_process(delta: float) -> void:
    if triggered:
        velocity = Vector2(RUN_SPEED * delta, 0)
    else:
        velocity = Vector2(WALK_SPEED * delta, 0)

    animated_sprite.play("idle")

    move_and_slide()