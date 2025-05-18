extends Node

@export var corpse: PackedScene
@export var corpse_player_has_flowers: PackedScene
@export var burning_corpse: PackedScene

var _fire_player


func _ready() -> void:
	GameState.corpse_burnt.connect(_on_corpse_burnt)
	Navigator.scene_transition_start.connect(_on_leaving)

	# if corpse has been burnt, burning
	if "burn_corpse" in GameState.choices:
		add_child(burning_corpse.instantiate())
		_fire_player = AudioManager.play_sound("fire", AudioManager.SoundType.AMBIENCE)

	elif "pick_flowers" in GameState.choices:
		add_child(corpse_player_has_flowers.instantiate())

	else:
		add_child(corpse.instantiate())


func _on_leaving() -> void:
	if _fire_player:
		AudioManager.fade_out_player(_fire_player, 2.)


func _exit_tree() -> void:
	if _fire_player:
		AudioManager.stop(_fire_player)


func _on_corpse_burnt():
	get_child(0).queue_free()
	add_child(burning_corpse.instantiate())
	_fire_player = AudioManager.play_sound("fire", AudioManager.SoundType.AMBIENCE)
