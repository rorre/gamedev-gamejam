extends Node

const level_scene = preload("res://scenes/screen/level.tscn")
const song_select_scene = preload("res://scenes/screen/song_select.tscn")
const result_scene = preload("res://scenes/screen/result.tscn")

var level: Level
var song_select: Node
var result: Node

var state = "select"


func _process(delta: float) -> void:
	if state == "result" and Input.is_action_just_pressed("ui_accept"):
		result.queue_free()
		result = null
		_display_song_select()


func _ready() -> void:
	_display_song_select()


func _display_song_select():
	song_select = song_select_scene.instantiate()
	song_select.song_selected.connect(_play_level)
	add_child(song_select)
	
	state = "select"


func _display_result(song: Song, difficulty: Difficulty, grades: Array[int]):
	result = result_scene.instantiate()
	result.song = song
	result.difficulty = difficulty
	result.grades = grades
	add_child(result)
	
	state = "result"


func _play_level(song: Song, diff: Difficulty) -> void:
	level = level_scene.instantiate()
	level.song = song
	level.difficulty = diff
	level.song_finished.connect(_on_level_song_finished)

	song_select.queue_free()
	song_select = null
	state = "playing"

	add_child(level)
	level.start()


func _on_level_song_finished(song: Song, difficulty: Difficulty, grades: Array[int]):
	level.queue_free()
	level = null
	_display_result(song, difficulty, grades)
