class_name DialogueBox
extends CanvasLayer

@export var panel: PanelContainer
@export var text_container: VBoxContainer
@export var indicator: RichTextLabel
@export var scroll_container: ScrollContainer

var current_event: DialogueEvent


func _ready() -> void:
	panel.gui_input.connect(_on_panel_input)


func start_dialogue_event(event: DialogueEvent):
	print("starting dialogue event " + event.event_id)
	current_event = event
	_show_next_line()
	print(event.event_id)


func _on_panel_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			_show_next_line()
			print("dialogue box click")


func _show_next_line() -> bool:
	if !current_event:
		return false
	var current_num_lines = text_container.get_child_count()
	if current_num_lines == len(current_event.lines):
		return false

	if current_num_lines == 0:
		indicator.visible = true

	if current_num_lines > 0:
		var last_line: RichTextLabel = text_container.get_child(current_num_lines - 1)
		last_line.theme_type_variation = "HistoryText"

	var next_dialogue_line = current_event.lines[text_container.get_child_count()]
	if next_dialogue_line is DialogueText:
		var new_line = RichTextLabel.new()
		new_line.bbcode_enabled = true
		new_line.text = next_dialogue_line.text
		new_line.fit_content = true
		text_container.add_child(new_line)
	if current_num_lines == len(current_event.lines) - 1:
		indicator.text = ""

	call_deferred("scroll_to_bottom")
	return true


func scroll_to_bottom():
	scroll_container.set_deferred("scroll_vertical", scroll_container.get_v_scroll_bar().max_value)
