extends CanvasLayer

signal dialogue_event_start
signal dialogue_event_end

@export var sidebar: PanelContainer
@export var events_vbox: VBoxContainer
@export var indicator: RichTextLabel
@export var scroll_container: ScrollContainer
@export var event_overlay: Control
@export var animation_player: AnimationPlayer
@export var event_container: PackedScene

var current_event: DialogueEvent
var current_event_vbox: VBoxContainer

var asking_question: bool = false
var current_answers_vbox: VBoxContainer


func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)
	sidebar.gui_input.connect(_on_panel_input)


func start_dialogue_event(event: DialogueEvent):
	sidebar.mouse_filter = Control.MOUSE_FILTER_STOP

	# create nodes
	var current_event_container = PanelContainer.new()
	current_event_container.theme_type_variation = "DialogueEvent"
	current_event_container.mouse_filter = Control.MOUSE_FILTER_PASS

	current_event_vbox = VBoxContainer.new()
	current_event_vbox.mouse_filter = Control.MOUSE_FILTER_PASS

	current_event_container.add_child(current_event_vbox)
	events_vbox.add_child(current_event_container)

	dialogue_event_start.emit()

	if current_event == null:
		animation_player.play("start_event")
		current_event = event
	else:
		current_event = event
		_show_next_line()

	indicator.text = "[b]>[/b]"


func _on_animation_finished(animation_name: String):
	if animation_name == "start_event":
		_show_next_line()
	elif animation_name == "end_event":
		current_event.callback()
		current_event = null


func _on_panel_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			_show_next_line()


func _show_next_line() -> bool:
	if !current_event:
		return false

	var current_num_lines = current_event_vbox.get_child_count()

	if current_num_lines == 0:
		indicator.text = "[b]>[/b]"
	else:
		var last_line = current_event_vbox.get_child(current_num_lines - 1)
		if last_line is RichTextLabel:
			last_line.theme_type_variation = "HistoryText"
		else:
			# @todo: idk
			pass

		if current_num_lines == len(current_event.lines):
			dialogue_event_end.emit()
			animation_player.play("end_event")
			indicator.text = " "
			return true

	var next_dialogue_line = current_event.lines[current_event_vbox.get_child_count()]
	if next_dialogue_line is DialogueText:
		var new_line = RichTextLabel.new()
		new_line.bbcode_enabled = true
		new_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		new_line.text = next_dialogue_line.text
		new_line.fit_content = true
		current_event_vbox.add_child(new_line)
	elif next_dialogue_line is DialogueQuestion:
		var new_line = VBoxContainer.new()
		new_line.theme_type_variation = "QuestionContainer"

		var prompt_text = RichTextLabel.new()
		prompt_text.bbcode_enabled = true
		prompt_text.fit_content = true
		prompt_text.text = "[b]" + next_dialogue_line.prompt + "[/b]"
		new_line.add_child(prompt_text)

		var answers_container = PanelContainer.new()
		answers_container.theme_type_variation = "ChoicesPanelContainer"
		new_line.add_child(answers_container)

		current_answers_vbox = VBoxContainer.new()
		answers_container.add_child(current_answers_vbox)

		for answer in next_dialogue_line.answers:
			var dialogue_option = next_dialogue_line.answers[answer] as DialogueOption

			var new_button = Button.new()
			new_button.text = dialogue_option.text
			new_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			new_button.theme_type_variation = "ChoiceButton"
			new_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			new_button.pressed.connect(record_choice.bind(answer, dialogue_option))
			current_answers_vbox.add_child(new_button)

		current_event_vbox.add_child(new_line)
		asking_question = true
		sidebar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sidebar.mouse_default_cursor_shape = Control.CURSOR_ARROW

	if current_num_lines == len(current_event.lines) - 1:
		indicator.text = "[b]>>[/b]"

	call_deferred("scroll_to_bottom")
	return true


func record_choice(choice_id: String, dialogue_option: DialogueOption):
	#GameState.choices[question_id] = choice_id
	GameState.record_action(choice_id)
	var answers = current_answers_vbox.get_children()
	for answer in answers:
		answer.queue_free()
	var margin_container = MarginContainer.new()
	var selected_answer = RichTextLabel.new()
	selected_answer.fit_content = true
	selected_answer.text = dialogue_option.text
	margin_container.add_child(selected_answer)
	current_answers_vbox.add_child(margin_container)
	asking_question = false
	if dialogue_option.next_event:
		start_dialogue_event(dialogue_option.next_event)
	else:
		dialogue_event_end.emit()
		animation_player.play("end_event")
		indicator.text = " "


func scroll_to_bottom():
	scroll_container.set_deferred("scroll_vertical", scroll_container.get_v_scroll_bar().max_value)


func clear_dialogue_box():
	var events = events_vbox.get_children()
	for event in events:
		event.queue_free()


func _callback():
	pass
