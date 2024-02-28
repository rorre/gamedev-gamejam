extends Node

const level = preload("res://scenes/screen/level.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_song_select_song_selected(song: Song, diff: Difficulty) -> void:
	var new_level: Level = level.instantiate()
	new_level.song = song
	new_level.difficulty = diff
	
	add_child(new_level)
	$"Song Select".queue_free()
	new_level.start()
