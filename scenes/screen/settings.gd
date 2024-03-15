extends Control

@onready var playfield = $Control/Playfield
@onready var settings = get_node("/root/UserSettings")
const chart = preload("res://songs/settings_chart.json")
var t: int = 0

var selected = 0
@onready var boxes = [
	$"VBoxContainer/Volume Control",
	$"VBoxContainer/Volume Control2",
	$"VBoxContainer/Volume Control3",
	$VBoxContainer/Speed
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playfield.load_chart(chart)
	$VBoxContainer/Speed.value = settings.speed
	$"VBoxContainer/Volume Control".value = settings.master_volume
	$"VBoxContainer/Volume Control2".value = settings.song_volume
	$"VBoxContainer/Volume Control3".value = settings.sfx_volume
	
	$VBoxContainer/Speed.changed.connect(func n(value): settings.speed = value)
	$"VBoxContainer/Volume Control".changed.connect(func n(value): settings.master_volume = value)
	$"VBoxContainer/Volume Control2".changed.connect(func n(value): settings.song_volume = value)
	$"VBoxContainer/Volume Control3".changed.connect(func n(value): settings.sfx_volume = value)

func process_box():
	for box in boxes:
		box.scale = Vector2(1, 1)
		box.enabled = false
	
	boxes[selected].scale = Vector2(1.05, 1.05)
	boxes[selected].enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_t = (t + int(delta * 1000)) % 2500
	if new_t < t:
		playfield.load_chart(chart)
		
	playfield.set_current_time(new_t)
	t = new_t
	
	if Input.is_action_just_pressed("ui_up"):
		selected = selected - 1
	elif Input.is_action_just_pressed("ui_down"):
		selected = selected + 1
	selected = clamp(selected, 0, 3)
	process_box()
