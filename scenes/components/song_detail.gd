extends Control

@export var song: Song:
	set(value):
		song = value
		_update_box()
		
@export var difficulty: Difficulty:
	set(value):
		difficulty = value
		_update_box()

# Called when the node enters the scene tree for the first time.
func _update_box():
	if not (song and difficulty):
		return
	
	$BoxContainer/TextureRect.texture = load(song.jacket)
	$Title.text = song.title
	$Artist.text = song.artist
	$Level.text = "Lv. " + difficulty.rating

func _ready():
	_update_box()
