extends Panel

enum NoteType {
	SLIDER = 1,
	NOTE = 2
}

@export var time: int = 0
@export var end_time: int = 0
@export var type: NoteType = NoteType.NOTE
@export var colsize: int = 1
@export var col: int = 0
@export var clicked: bool = false

var slider_added = false;
const WIDTH = 100;
const HEIGHT = 10
const px_per_ms = (605 - HEIGHT) / 500.0
var x_size

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_height = px_per_ms * max((end_time - time), 10)
	x_size = colsize * WIDTH
	set_size(Vector2(x_size, new_height))
	set_position(Vector2(100 * col, -new_height))
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_type(t: String):
	if t == "note":
		type = NoteType.NOTE
	else:
		type = NoteType.SLIDER
		x_size = colsize * WIDTH
		var new_height = px_per_ms * (end_time - time)
		set_size(Vector2(x_size, new_height))

		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = Color.GREEN
		style.corner_radius_bottom_left = 10
		style.corner_radius_bottom_right = 10
		style.corner_radius_top_left = 10
		style.corner_radius_top_right = 10
		style.bg_color.a = 0.25
		add_theme_stylebox_override("panel", style)
