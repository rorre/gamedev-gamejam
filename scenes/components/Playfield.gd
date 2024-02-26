extends Control

signal note_judged(judgement)

@export var current_time: int = 0
@export var ms_window: int = 500

var flashes: Array[ColorRect]
var queue: Array[Node] = [];
var note = preload("res://scenes/components/note.tscn")


# Called when the node enters the scene tree for the first time.
func _init():
	var chart_str = FileAccess.get_file_as_string("res://master.json")
	var chart = JSON.new()
	var err = chart.parse(chart_str)

	var objects = chart.data["objects"]
	for data in objects:
		var obj = note.instantiate()
		obj.col = data[0]
		obj.time = data[1]
		obj.colsize = data[3]
		obj.end_time = data[4]
		obj.set_type(data[2])
		
		queue.append(obj)
		add_child(obj)


func find_earliest_from_col(col: int):
	for obj in queue:
		if (
			obj.type == 2
			and (obj.col == col or (obj.col < col and obj.col + obj.colsize - 1 >= col))
		):
			return obj
	return null


func handle_click(note: Node):
	var delta = abs(note.time - current_time)
	if delta > 200:
		return false
	elif delta > 150:
		emit_signal("note_judged", 1)
	elif delta > 100:
		emit_signal("note_judged", 2)
	else:
		emit_signal("note_judged", 3)

	note.clicked = true
	note.queue_free()
	return true


func process_col(input_name: StringName, idx: int):	
	if Input.is_action_just_pressed(input_name):
		var earliest = find_earliest_from_col(idx)
		if earliest:
			var success = handle_click(earliest)
			if success:
				return earliest
	return null


func flash_col(i: int):
	var tween = create_tween()
	tween.tween_property(flashes[i], "modulate:a", 0.5, 0.075)
	tween.tween_property(flashes[i], "modulate:a", 0.0, 0.075)
	tween.play()


func _ready() -> void:
	flashes = [$FlashRow1, $FlashRow2, $FlashRow3, $FlashRow4]


func _process(delta: float):
	var inputs = ["col_1", "col_2", "col_3", "col_4"]
	var i = 0;
	while i < 4:
		var clicked = process_col(inputs[i], i)
		if clicked:
			for j in range(clicked.col, clicked.col + clicked.colsize):
				flash_col(j)
			i = clicked.col + clicked.colsize
			continue
		else:
			i += 1


func set_current_time(t):
	current_time = t
	var i = 0
	while true:
		if i >= len(queue):
			break
		
		var note = queue[i]
		if not is_instance_valid(note) or note.clicked:
			queue.remove_at(i)
			continue

		if t - note.time > 200 and t - note.end_time > 200:
			note.queue_free()
			queue.remove_at(i)
			
			if note.type == 2:
				emit_signal("note_judged", 0)
			continue
		
		if not note.visible and note.time - t < 700:
			note.visible = true;
		
		var orig: Vector2 = note.position
		var orig_size: Vector2 = note.size
		note.position = Vector2(orig.x, 605 * (1.0 - (note.time - t) / ms_window) - orig_size.y)
		i += 1



func _on_note_judged(judgement: int) -> void:
	var message = "Miss"
	if judgement == 1:
		message = "Good"
	elif judgement == 2:
		message = "Great"
	elif judgement == 3:
		message = "Perfect"
	
	$Judgement.text = message
	var tween = create_tween()
	tween.tween_property($Judgement, "transform:scale", Vector2(1.1, 1.1), 0.025)
	tween.tween_property($Judgement, "transform:scale", Vector2(1.0, 1.0), 0.025)
	tween.play()
