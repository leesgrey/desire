extends CanvasLayer

@export var tooltip: Control
@export var location_text: RichTextLabel

var is_showing = false


func _ready() -> void:
	Navigator.scene_transition_start.connect(hide_tooltip)
	DialogueManager.dialogue_event_start.connect(hide_tooltip)


func show_tooltip(text: String):
	location_text.text = text
	tooltip.visible = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		tooltip.position = event.position


func hide_tooltip():
	tooltip.visible = false
