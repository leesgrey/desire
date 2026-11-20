extends Node2D

@export var text_trigger_layers: Dictionary[String, Node2D]
@export var narration: RichTextLabel
@export var instruction_soft: RichTextLabel
@export var instruction_hard: RichTextLabel
@export var ghost_trigger: Area2D
@export var timer: Timer
@export var ghost: CharacterBody2D

var entered_from_left = !GameState.previous_location
var current_scene: TextScene
var hard_instruction_triggered := false

func _ready() -> void:
	SignalBus.player_walking_left.connect(_on_player_walking_left)
	SignalBus.player_walking_right.connect(_on_player_walking_right)
	SignalBus.update_narration.connect(_update_narration)
	if entered_from_left:  # Starting scene
		text_trigger_layers["start"].visible = true  # TODO: this doesnt work !!!!!!!!!!!!!
	reset()
	ghost_trigger.body_entered.connect(_on_ghost_trigger)
	timer.timeout.connect(_reset_ghost)

func _update_narration(text):
	narration.text = text

func _on_player_walking_left():
	show_instruction()

func _on_player_walking_right():
	reset()

func show_instruction():
	narration.visible = false
	ghost.visible = true

	if hard_instruction_triggered:
		instruction_hard.visible = true
	else:
		instruction_soft.visible = true

func reset():
	narration.visible = true
	instruction_soft.visible = false
	instruction_hard.visible = false
	if !ghost.triggered:
		ghost.visible = false


func _on_ghost_trigger(_body):
	print("ghost triggered")
	ghost.triggered = true

func _reset_ghost():
	# move ghost back to starting position
	pass
