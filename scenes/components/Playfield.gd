extends Control

signal note_judged(judgement: int, type: Note.NoteType)

@export var current_time: int = 0
@export var total_notes: int = 0
@onready var settings = get_node("/root/UserSettings")

var flashes: Array[ColorRect]
var queue: Array[Note] = []
var ticks_queue: Array[Note] = []
const note = preload("res://scenes/components/note.tscn")
const particle = preload("res://scenes/components/box_particle.tscn")
const inputs = ["col_1", "col_2", "col_3", "col_4"]

enum InputType { TAP, HOLD }
const PERFECT_WINDOW = 33 # 2 frames
const GREAT_WINDOW = 66 # 4 frames
const GOOD_WINDOW = 83 # 5 frames
const MISS_WINDOW = 100 # 6 frames


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
		total_notes += 1


func find_earliest_from_col(note_queue: Array[Note], col: int) -> Note:
	for obj in note_queue:
		if is_instance_valid(obj) and obj.is_valid_click(col) and not obj.clicked:
			return obj
	return null


func handle_click(note: Note) -> bool:
	var delta = abs(current_time - note.time)
	if note.type == Note.NoteType.TICK:
		if delta < MISS_WINDOW and not note.clicked:
			note.clicked = true
			note.queue_free()
			emit_signal("note_judged", 3, note.type)
			return true
		return false

	if delta > MISS_WINDOW + 33: # + 1 frame
		return false
	
	if note.type == Note.NoteType.SLIDER:
		return true
	
	if delta > MISS_WINDOW:
		emit_signal("note_judged", 0, note.type)
	elif delta > GOOD_WINDOW:
		emit_signal("note_judged", 1, note.type)
	elif delta > GREAT_WINDOW:
		emit_signal("note_judged", 2, note.type)
	else:
		emit_signal("note_judged", 3, note.type)

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
	flashes = [$Flashes/FlashRow1, $Flashes/FlashRow2, $Flashes/FlashRow3, $Flashes/FlashRow4]
	await get_tree().create_timer(2).timeout
	var tween = create_tween()
	tween.tween_property($Guide, "modulate:a", 0, 1)

func reset():
	total_notes = 0
	for obj in queue:
		obj.queue_free()
	
	for obj in ticks_queue:
		obj.queue_free()
		
	queue = []
	ticks_queue = []

func load_chart(chart_file: Resource):
	# Reset states
	reset()

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
		else:
			total_notes += 1

		queue.append(obj)

	ticks_queue.sort_custom(compare_note_time)
	queue.sort_custom(compare_note_time)


func compare_note_time(a: Note, b: Note):
	return a.time < b.time


var previous_flashed: Array[int] = []

func note_hit_particle(col: int):
	var p: Line2D = particle.instantiate()
	p.scale = Vector2(0.0, 0.0)
	p.position = Vector2(col * 100 + 50, 605)
	p.z_index = 50
	p.width = 2
	add_child(p)
	
	var tween = create_tween()
	tween.tween_property(p, "position", Vector2(col * 100 + 50, 600 - 50), 0.1)
	tween.parallel().tween_property(p, "rotation_degrees", 45, 0.1)
	tween.parallel().tween_property(p, "scale", Vector2(1.0, 1.0), 0.1)
	tween.tween_property(p, "self_modulate:a", 0, 0.1)
	tween.tween_callback(p.queue_free)
	tween.play()

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
				note_hit_particle(j)
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

		if note.time > t + settings.ms_window + 2000:
			break

		if not note.is_inside_tree():
			add_child(note)
		# Fix for LN if head is missed, just assume clicked
		# so the other parts of the code didnt always pick this
		if t - note.time > MISS_WINDOW and note.type == 1:
			note.clicked = true

		if t - note.time > MISS_WINDOW and t - note.end_time > 200:
			note.queue_free()
			queue.remove_at(i)

			if note.type == 2:
				emit_signal("note_judged", 0, note.type)
			continue

		if not note.visible and note.time - t < (settings.ms_window + 2000):
			note.visible = true

		var orig: Vector2 = note.position
		var orig_size: Vector2 = note.size
		note.position = Vector2(orig.x, 605 * (1.0 - (note.time - t) / settings.ms_window) - orig_size.y)
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

		if note.time > t + settings.ms_window + 2000:
			break

		if t > note.time + GOOD_WINDOW:
			note.queue_free()
			ticks_queue.remove_at(i)

			if not note.clicked:
				if is_instance_valid(note.parent):
					note.parent.modulate.a = 0.5
				emit_signal("note_judged", 0, note.type)
			continue
		i += 1


func set_current_time(t):
	current_time = t
	_handle_notes(t)
	_handle_holds(t)


func _on_note_judged(judgement: int, type: Note.NoteType) -> void:
	var message = "Miss"
	if judgement == 1:
		message = "Good"
	elif judgement == 2:
		message = "Great"
	elif judgement == 3:
		message = ""

	$Judgement.text = message

