extends Control
class_name Level

signal song_finished(song: Song, difficulty: Difficulty, grades: Array[int])

@export var song: Song
@export var difficulty: Difficulty
@onready var window = get_window()

# [miss, good, great, perfect]
var grades: Array[int] = [0, 0, 0, 0]
const note_hs = preload("res://assets/sfx/note.ogg")
const tick_hs = preload("res://assets/sfx/tick.ogg")


func _ready():
	if song and difficulty:
		set_playing(song, difficulty)


func set_playing(song: Song, difficulty: Difficulty):
	$AudioStreamPlayer.stream = load(song.audio)
	$Playfield.load_chart(load(difficulty.chart))

	$HUD/SongDetail.song = song
	$HUD/SongDetail.difficulty = difficulty


func start():
	$AudioStreamPlayer.play()


func _process(delta):
	var time = $AudioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	time *= 1000

	$Playfield.set_current_time(time)
	if song.gimmick:
		song.gimmick.on_time_change(window, time)


func _on_playfield_note_judged(judgement: int, type: Note.NoteType) -> void:
	grades[judgement] += 1

	var sum_notes = grades.reduce(func(acc, e): return acc + e, 0)
	var acc = (grades[3] * 1 + grades[2] * 0.75 + grades[1] * 0.5) / sum_notes * 100
	var rounded = snapped(acc, 0.01)
	$HUD/Accuracy.text = "%.2f%%" % rounded
	
	if judgement == 0:
		return
		
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
	song_finished.emit(song, difficulty, grades)
