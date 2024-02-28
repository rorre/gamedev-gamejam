extends Node

func _ready() -> void:
	$Level.hide()

func _process(delta: float) -> void:
	pass

func _on_song_select_song_selected(song: Song, diff: Difficulty) -> void:
	$Level.set_playing(song, diff)
	$"Song Select".hide()
	$Level.show()
	$Level.start()


func _on_level_song_finished(song: Song, difficulty: Difficulty, grades: Array[int]):
	print(grades)
	$Level.hide()
	$"Song Select".show()
