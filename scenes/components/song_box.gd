extends Panel
class_name SongBox

@export var song: Song
@export var diff_idx: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Artist.text = song.artist
	$VBoxContainer/Title.text = song.title
	
	$VBoxContainer/BoxContainer/TextureRect.texture = load(song.jacket)

func set_diff_idx(idx: int):
	diff_idx = idx
	$Panel/Difficulty.text = song.difficulties[diff_idx].rating

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
