extends Node
class_name Level

signal song_finished(song: Song, difficulty: Difficulty, grades: Array[int])

@export var song: Song
@export var difficulty: Difficulty

# [miss, good, great, perfect]
var grades: Array[int] = [0,0,0,0]

func _ready():
	if song and difficulty:
		set_playing(song, difficulty)

func set_playing(song: Song, difficulty: Difficulty):
	$AudioStreamPlayer.stream = load(song.audio)
	$Playfield.load_chart(load(difficulty.chart))
	
	$HUD/VBoxContainer/Artist.text = song.artist
	$HUD/VBoxContainer/Title.text = song.title
	$HUD/VBoxContainer/Level.text = "Lv. " + difficulty.rating

func start():
	$AudioStreamPlayer.play()

func _process(delta):
	var time = $AudioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	time *= 1000

	$Playfield.set_current_time(time)


func _on_playfield_note_judged(judgement: int) -> void:
	grades[judgement] += 1
	
	var sum_notes =  grades.reduce(func (acc, e): return acc + e, 0)
	var acc = (grades[3] * 1 + grades[2] * 0.75 + grades[1] * 0.5) / sum_notes * 100
	var rounded = snapped(acc, 0.01)
	$HUD/Accuracy.text = "%.2f%%" % rounded


func _on_audio_stream_player_finished():
	song_finished.emit(song, difficulty, grades)
