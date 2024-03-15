extends Control
class_name Level

signal song_finished(song: Song, difficulty: Difficulty, grades: Array[int], accuracy: float, max_combo: int)

@export var song: Song
@export var difficulty: Difficulty
@onready var window = get_window()

# [miss, good, great, perfect]
var grades: Array[int] = [0, 0, 0, 0]
var combo = 0
var best_combo = 0
const note_hs = preload("res://assets/sfx/note.ogg")
const tick_hs = preload("res://assets/sfx/tick.ogg")
var rng = RandomNumberGenerator.new()
const particle = preload("res://scenes/components/box_particle.tscn")

func _ready():
	rng.randomize()
	UserSettings.speed_change.connect(_on_speed_change)
	_on_speed_change(UserSettings.effective_speed)
	if song and difficulty:
		set_playing(song, difficulty)


func set_playing(song: Song, difficulty: Difficulty):
	$AudioStreamPlayer.stream = load(song.audio)
	$Playfield.load_chart(load(difficulty.chart))

	$HUD/SongDetail.song = song
	$HUD/SongDetail.difficulty = difficulty
	$HUD/BPM/Value.text = str(song.bpm[0][1])


func start():
	$AudioStreamPlayer.play()


func restart():
	$AudioStreamPlayer.seek(0)
	grades = [0, 0, 0, 0]
	$HUD/Accuracy.text = "100.00%"
	$Playfield.load_chart(load(difficulty.chart))
	

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$AudioStreamPlayer.stop()
		_on_audio_stream_player_finished()
		return
	
	if Input.is_action_just_pressed("restart"):
		if song.gimmick:
			song.gimmick.cleanup(window)
		restart()
		return

	var time = $AudioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	time *= 1000

	$Playfield.set_current_time(time)
	if song.gimmick:
		song.gimmick.on_time_change(window, time)
	
	var progress = time / ($AudioStreamPlayer.stream.get_length() * 1000.0)
	$Progress.scale = Vector2(progress, 1)
	
	if len(song.bpm) >= 1 and time > song.bpm[0][0]:
		var new_bpm = song.bpm.pop_front()
		$HUD/BPM/Value.text = str(new_bpm[1])

func _on_playfield_note_judged(judgement: int, type: Note.NoteType) -> void:
	grades[judgement] += 1

	var sum_notes = grades.reduce(func(acc, e): return acc + e, 0)
	var acc = (grades[3] * 1 + grades[2] * 0.75 + grades[1] * 0.5) / sum_notes * 100
	var accuracy = snapped(acc, 0.01)
	$HUD/Accuracy.text = "%.2f%%" % accuracy
	
	if judgement == 0:
		combo = 0
		return

	combo += 1
	best_combo = max(combo, best_combo)
	$HUD/Combo/Value.text = str(best_combo)

	var sfx_player = AudioStreamPlayer.new()
	if type == Note.NoteType.TICK:
		sfx_player.stream = tick_hs
	else:
		sfx_player.stream = note_hs
	sfx_player.bus = "SFX"
	
	add_child(sfx_player)
	sfx_player.play()
	await sfx_player.finished
	sfx_player.queue_free()


func _on_audio_stream_player_finished():
	if song.gimmick:
		song.gimmick.cleanup(window)
	
	var real_acc = (grades[3] * 1 + grades[2] * 0.75 + grades[1] * 0.5) / $Playfield.total_notes * 100
	song_finished.emit(song, difficulty, grades, real_acc, best_combo)


func _on_particle_timer_timeout() -> void:
	var tween = create_tween()
	for _i in range(rng.randi_range(5, 10)):
		var p: Line2D = particle.instantiate()
		p.rotation_degrees = 45;
		
		var scale = rng.randf_range(0.25,0.75)
		var x = rng.randi_range(0, 1280)
		p.position = Vector2(x, 900)
		p.scale = Vector2(scale, scale)
		p.z_index = 0
		p.self_modulate.a = 0.5
		p.modulate.a = 0.5
		tween.tween_property(p, "position", Vector2(x, -100), rng.randf_range(5, 10))
		tween.tween_callback(p.queue_free)
		
		add_child(p)
	tween.play()


func _on_speed_change(value: float):
	$HUD/Speed/Value.text = "%.2f" % value

