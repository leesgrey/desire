extends Node

@export var chest: PackedScene
@export var burning_chest: PackedScene

var _fire_player: AudioStreamPlayer


func _ready() -> void:
	GameState.writings_burnt.connect(_on_writings_burnt)
	Navigator.scene_transition_start.connect(_on_leaving)

	# if chest has been burnt, burning
	if "burn_writings" in GameState.choices:
		add_child(burning_chest.instantiate())
		_fire_player = AudioManager.play_sound("fire", AudioManager.SoundType.AMBIENCE)

	# else uncovered
	else:
		add_child(chest.instantiate())


func _on_leaving() -> void:
	if _fire_player:
		AudioManager.fade_out_player(_fire_player, 2.)


func _exit_tree() -> void:
	if _fire_player:
		AudioManager.stop(_fire_player)


func _on_writings_burnt():
	get_child(0).queue_free()
	add_child(burning_chest.instantiate())
	_fire_player = AudioManager.play_sound("fire", AudioManager.SoundType.AMBIENCE)
