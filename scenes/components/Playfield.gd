extends Control

signal note_judged(judgement)

@export var current_time: int = 0
@export var ms_window: int = 500

var flashes: Array[ColorRect]
var queue: Array[Note] = []
var ticks_queue: Array[Note] = []
const note = preload("res://scenes/components/note.tscn")
const inputs = ["col_1", "col_2", "col_3", "col_4"]

enum InputType { TAP, HOLD }


func generate_ticks(slider: Note):
	var start = slider.time
	var end = slider.end_time
	for i in range(start, end, 100):
		var tick: Note = note.instantiate()
		tick.time = i
		tick.col = slider.col
		tick.colsize = slider.colsize
		tick.end_time = i
		tick.parent = slider
		tick.set_type("tick")

		ticks_queue.append(tick)


func find_earliest_from_col(note_queue: Array[Note], col: int) -> Note:
	for obj in note_queue:
		if is_instance_valid(obj) and obj.is_valid_click(col) and not obj.clicked:
			return obj
	return null


func handle_click(note: Node) -> bool:
	var delta = abs(current_time - note.time)
	if note.type == 3:
		if delta < 100 and not note.clicked:
			note.clicked = true
			note.queue_free()
			emit_signal("note_judged", 3)
			return true
		return false

	if delta > 250:
		return false
	elif delta > 200:
		emit_signal("note_judged", 0)
	elif delta > 150:
		emit_signal("note_judged", 1)
	elif delta > 100:
		emit_signal("note_judged", 2)
	else:
		emit_signal("note_judged", 3)

	note.clicked = true
	if note.type == 2:
		note.queue_free()
	return true


func process_col(input_name: StringName, idx: int, method: InputType) -> Note:
	var is_valid: bool
	var note_queue: Array[Note]
	if method == InputType.TAP:
		is_valid = Input.is_action_just_pressed(input_name)
		note_queue = queue
	elif method == InputType.HOLD:
		is_valid = Input.is_action_pressed(input_name)
		note_queue = ticks_queue

	if is_valid:
		var earliest = find_earliest_from_col(note_queue, idx)
		if earliest:
			var success = handle_click(earliest)
			if success:
				return earliest
	return null


func flash_col(i: int):
	if i < 0 or i > 3:
		return

	var tween = create_tween()
	tween.tween_property(flashes[i], "modulate:a", 0.5, 0.075)
	tween.tween_property(flashes[i], "modulate:a", 0.0, 0.075)
	tween.play()


func _ready() -> void:
	flashes = [$FlashRow1, $FlashRow2, $FlashRow3, $FlashRow4]


func load_chart(chart_file: Resource):
	# Reset states
	queue = []
	ticks_queue = []

	var chart_str = FileAccess.get_file_as_string(chart_file.resource_path)
	var chart = JSON.new()
	chart.parse(chart_str)

	var objects = chart.data["objects"]
	for data in objects:
		var obj: Note = note.instantiate()
		obj.col = data[0]
		obj.time = data[1]
		obj.colsize = data[3]
		obj.end_time = data[4]
		obj.set_type(data[2])

		if data[2] == "slider":
			generate_ticks(obj)

		queue.append(obj)
		add_child(obj)

	ticks_queue.sort_custom(compare_note_time)
	queue.sort_custom(compare_note_time)


func compare_note_time(a: Note, b: Note):
	return a.time < b.time


var previous_flashed: Array[int] = []


func _process_click():
	var flashed_cols: Array[int] = []
	var i = 0
	while i < 4:
		if i in previous_flashed:
			i += 1
			continue

		var clicked = process_col(inputs[i], i, InputType.TAP)
		if clicked:
			for j in range(clicked.col, clicked.col + clicked.colsize):
				flashed_cols.append(j)
				flash_col(j)
			i = clicked.col + clicked.colsize
			continue

		i += 1

	i = 0
	while i < 4:
		if Input.is_action_just_pressed(inputs[i]):
			flash_col(i)
		i += 1

	previous_flashed = flashed_cols


func _process_hold():
	for i in range(4):
		var tick = process_col(inputs[i], i, InputType.HOLD)
		if tick:
			tick.parent.modulate.a = 1


func _process(delta: float):
	_process_click()
	_process_hold()


func _handle_notes(t: float):
	var i = 0
	while true:
		if i >= len(queue):
			break

		var note = queue[i]
		if not is_instance_valid(note) or (note.clicked and note.type != 1):
			queue.remove_at(i)
			continue

		if note.time > t + ms_window:
			break

		# Fix for LN if head is missed, just assume clicked
		# so the other parts of the code didnt always pick this
		if t - note.time > 200 and note.type == 1:
			note.clicked = true

		if t - note.time > 200 and t - note.end_time > 200:
			note.queue_free()
			queue.remove_at(i)

			if note.type == 2:
				emit_signal("note_judged", 0)
			continue

		if not note.visible and note.time - t < 700:
			note.visible = true

		var orig: Vector2 = note.position
		var orig_size: Vector2 = note.size
		note.position = Vector2(orig.x, 605 * (1.0 - (note.time - t) / ms_window) - orig_size.y)
		i += 1


func _handle_holds(t: float):
	var i = 0
	while true:
		if i >= len(ticks_queue):
			break

		var note = ticks_queue[i]
		if not is_instance_valid(note) or note.clicked:
			ticks_queue.remove_at(i)
			continue

		if note.time > t + ms_window:
			break

		# 100ms buffer :>
		if t > note.time + 100:
			note.queue_free()
			ticks_queue.remove_at(i)

			if not note.clicked:
				if is_instance_valid(note.parent):
					note.parent.modulate.a = 0.5
				emit_signal("note_judged", 0)
			continue
		i += 1


func set_current_time(t):
	current_time = t
	_handle_notes(t)
	_handle_holds(t)


func _on_note_judged(judgement: int) -> void:
	var message = "Miss"
	if judgement == 1:
		message = "Good"
	elif judgement == 2:
		message = "Great"
	elif judgement == 3:
		message = ""

	$Judgement.text = message
