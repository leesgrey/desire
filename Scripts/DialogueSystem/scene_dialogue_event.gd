class_name SceneDialogueEvent
extends DialogueEvent

@export var next_scene: String


func callback():
	Navigator.change_scene(next_scene)
