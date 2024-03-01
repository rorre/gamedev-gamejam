extends Control

@export var song: Song
@export var difficulty: Difficulty

# Called when the node enters the scene tree for the first time.
func _ready():
	$SongDetail.song = song
	$SongDetail.difficulty = difficulty
