class_name WalkTrigger
extends Resource

enum WalkDirection {
    LEFT,
    RIGHT
}

@export var direction: WalkDirection
@export var text: String