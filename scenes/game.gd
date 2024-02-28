extends Node

const level_scene = preload("res://scenes/screen/level.tscn")
const song_select_scene = preload("res://scenes/screen/song_select.tscn")

var level: Level
var song_select: Node


func _ready() -> void:
	_display_song_select()


func _display_song_select():
	song_select = song_select_scene.instantiate()
	song_select.song_selected.connect(_play_level)
	add_child(song_select)


func _play_level(song: Song, diff: Difficulty) -> void:
	level = level_scene.instantiate()
	level.song = song
	level.difficulty = diff
	level.song_finished.connect(_on_level_song_finished)

	song_select.queue_free()
	song_select = null

	add_child(level)
	level.start()


func _on_level_song_finished(song: Song, difficulty: Difficulty, grades: Array[int]):
	print(grades)
	level.queue_free()
	level = null
	_display_song_select()
