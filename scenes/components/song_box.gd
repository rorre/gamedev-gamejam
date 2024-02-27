extends Panel
class_name SongBox

@export var title: String
@export var artist: String
@export var difficulty: int
@export var jacket: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Artist.text = artist
	$VBoxContainer/Title.text = title
	$Panel/Difficulty.text = str(difficulty)
	$VBoxContainer/BoxContainer/TextureRect.texture = jacket


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
