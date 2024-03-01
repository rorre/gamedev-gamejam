extends Node

const level_scene = preload("res://scenes/screen/level.tscn")
const song_select_scene = preload("res://scenes/screen/song_select.tscn")
const result_scene = preload("res://scenes/screen/result.tscn")
const settings_scene = preload("res://scenes/screen/settings.tscn")
const prestart_scene = preload("res://scenes/screen/prestart.tscn")
const splash_scene = preload("res://scenes/screen/splash.tscn")

var current_screen: Control
var state = "splash"

func change_screen(new_screen: Node):
	if current_screen:
		new_screen.position = Vector2(-1280, 0)
		add_child(new_screen)
	
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
		tween.tween_property(current_screen, "position", Vector2(1280, 0), 1)
		tween.tween_property(new_screen, "position", Vector2(0, 0), 1)
		tween.play()
		await tween.finished
		current_screen.queue_free()
	else:
		add_child(new_screen)
	
	current_screen = new_screen


func _process(delta: float) -> void:
	if state == "select" and Input.is_action_just_pressed("settings"):
		_display_settings()
	if state == "result" and Input.is_action_just_pressed("ui_accept"):
		_display_song_select()
	if state == "settings" and Input.is_action_just_pressed("ui_cancel"):
		_display_song_select()
	if state == "splash" and Input.is_action_just_pressed("ui_accept"):
		var song_select = song_select_scene.instantiate()
		song_select.modulate.a = 0
		
		
		add_child(song_select)
	
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_property(current_screen, "modulate:a", 0, 1)
		tween.tween_property(song_select, "modulate:a", 1, 1)
		tween.play()
		await tween.finished
		
		current_screen.queue_free()
		current_screen = song_select
		song_select.song_selected.connect(_play_level)
		state = "select"

func _ready() -> void:
	_display_splash()


func _display_splash():
	current_screen = splash_scene.instantiate()
	current_screen.modulate.a = 0
	add_child(current_screen)
	var tween = get_tree().create_tween()
	tween.tween_property(current_screen, "modulate:a", 1, 1)
	tween.play()

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
	var preview = prestart_scene.instantiate()
	preview.song = song
	preview.difficulty = diff
	
	await change_screen(preview)
	await get_tree().create_timer(1).timeout
	
	var level = level_scene.instantiate()
	level.song = song
	level.difficulty = diff
	level.song_finished.connect(_on_level_song_finished)
	state = "playing"

	await change_screen(level)
	level.start()

func _display_settings():
	state = "settings"
	change_screen(settings_scene.instantiate())

func _on_level_song_finished(song: Song, difficulty: Difficulty, grades: Array[int]):
	_display_result(song, difficulty, grades)
