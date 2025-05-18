extends InteractableObject

@export var leave_forest_event: DialogueEvent


func _on_click():
	DialogueManager.start_dialogue_event(leave_forest_event)

	#Navigator.change_scene("ending", false, true, true)
