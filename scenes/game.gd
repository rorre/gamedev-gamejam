extends Node

const level_scene = preload("res://scenes/screen/level.tscn")
const song_select_scene = preload("res://scenes/screen/song_select.tscn")
const result_scene = preload("res://scenes/screen/result.tscn")
const settings_scene = preload("res://scenes/screen/settings.tscn")

var current_screen: Node
var state = "select"

func change_screen(new_screen: Node):
	if current_screen:
		current_screen.queue_free()
	
	current_screen = new_screen
	add_child(new_screen)


func _process(delta: float) -> void:
	if state == "select" and Input.is_action_just_pressed("settings"):
		_display_settings()
	if state == "result" and Input.is_action_just_pressed("ui_accept"):
		_display_song_select()
	if state == "settings" and Input.is_action_just_pressed("ui_cancel"):
		_display_song_select()


func _ready() -> void:
	_display_song_select()


func _display_song_select():
	var song_select = song_select_scene.instantiate()
	song_select.song_selected.connect(_play_level)
	change_screen(song_select)
	
	state = "select"


func _display_result(song: Song, difficulty: Difficulty, grades: Array[int]):
	var result = result_scene.instantiate()
	result.song = song
	result.difficulty = difficulty
	result.grades = grades
	change_screen(result)
	
	state = "result"


func _play_level(song: Song, diff: Difficulty) -> void:
	var level = level_scene.instantiate()
	level.song = song
	level.difficulty = diff
	level.song_finished.connect(_on_level_song_finished)
	state = "playing"

	change_screen(level)
	level.start()

func _display_settings():
	state = "settings"
	change_screen(settings_scene.instantiate())

func _on_level_song_finished(song: Song, difficulty: Difficulty, grades: Array[int]):
	_display_result(song, difficulty, grades)
