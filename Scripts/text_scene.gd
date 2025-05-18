extends Node

@export var text_list: Array[String]
@export var text_container: VBoxContainer
@export var next_scene: String
@export var scroll_container: ScrollContainer
@export var indicator: RichTextLabel

@export var debug_force_allow_input: bool = false


func _ready() -> void:
	DialogueManager.visible = false
	Navigator.scene_transition_end.connect(_begin_scene)
	if !debug_force_allow_input:
		process_mode = Node.PROCESS_MODE_DISABLED


func _begin_scene() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_show_next_line()


func _show_next_line() -> bool:
	var current_num_lines = text_container.get_child_count()
	if current_num_lines == len(text_list):
		return false

	if current_num_lines == 0:
		indicator.visible = true

	if current_num_lines > 0:
		var last_line: RichTextLabel = text_container.get_child(current_num_lines - 1)
		last_line.theme_type_variation = "HistoryText"

	var new_line = RichTextLabel.new()
	new_line.bbcode_enabled = true
	new_line.text = text_list[text_container.get_child_count()]
	new_line.fit_content = true
	new_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_container.add_child(new_line)
	if current_num_lines == len(text_list) - 1:
		indicator.text = "[b]>>[/b]"

	call_deferred("scroll_to_bottom")
	return true


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			if !_show_next_line():
				Navigator.change_scene(next_scene, false, true, true)


func scroll_to_bottom():
	scroll_container.set_deferred("scroll_vertical", scroll_container.get_v_scroll_bar().max_value)
