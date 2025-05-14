extends CanvasLayer

signal dialogue_event_start
signal dialogue_event_end

@export var panel: PanelContainer
@export var events_vbox: VBoxContainer
@export var indicator: RichTextLabel
@export var scroll_container: ScrollContainer
@export var event_overlay: Control
@export var animation_player: AnimationPlayer

var current_event: DialogueEvent
var current_event_vbox: VBoxContainer

func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)
	panel.gui_input.connect(_on_panel_input)

func start_dialogue_event(event: DialogueEvent):
	print("starting dialogue event " + event.event_id)
	current_event = event
	var current_event_container = PanelContainer.new()
	current_event_container.theme_type_variation = "DialogueEvent"
	current_event_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	current_event_vbox = VBoxContainer.new()
	current_event_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	current_event_container.add_child(current_event_vbox)
	events_vbox.add_child(current_event_container)
	dialogue_event_start.emit()
	animation_player.play("start_event")
	indicator.text = "[b]>[/b]"

	print(event.event_id)


func _on_animation_finished(animation_name: String):
	if animation_name == "start_event":
		_show_next_line()


func _on_panel_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			_show_next_line()


func _show_next_line() -> bool:
	if !current_event:
		return false

	var current_num_lines = current_event_vbox.get_child_count()
	print(str(current_num_lines) + "/" + str(len(current_event.lines)))

	if current_num_lines == 0:
		indicator.visible = true
	else:
		var last_line: RichTextLabel = current_event_vbox.get_child(current_num_lines - 1)
		last_line.theme_type_variation = "HistoryText"

		if current_num_lines == len(current_event.lines):
			print("clicking on last line, ending event")
			dialogue_event_end.emit()
			current_event = null
			animation_player.play("end_event")
			indicator.visible = false
			return true

	var next_dialogue_line = current_event.lines[current_event_vbox.get_child_count()]
	if next_dialogue_line is DialogueText:
		var new_line = RichTextLabel.new()
		new_line.bbcode_enabled = true
		new_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		new_line.text = next_dialogue_line.text
		new_line.fit_content = true
		current_event_vbox.add_child(new_line)
	if current_num_lines == len(current_event.lines) - 1:
		indicator.text = "[b]>>[/b]"

	call_deferred("scroll_to_bottom")
	return true


func scroll_to_bottom():
	scroll_container.set_deferred("scroll_vertical", scroll_container.get_v_scroll_bar().max_value)


func clear_dialogue_box():
	var events = events_vbox.get_children()
	for event in events:
		event.queue_free()
