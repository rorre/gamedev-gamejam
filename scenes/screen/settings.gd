extends CanvasLayer

@onready var playfield = $Control/Playfield

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
	$VBoxContainer/Speed.value = UserSettings.speed
	$"VBoxContainer/Volume Control".value = UserSettings.master_volume
	$"VBoxContainer/Volume Control2".value = UserSettings.song_volume
	$"VBoxContainer/Volume Control3".value = UserSettings.sfx_volume
	
	$VBoxContainer/Speed.changed.connect(func n(value): UserSettings.speed = value)
	$"VBoxContainer/Volume Control".changed.connect(func n(value): UserSettings.master_volume = value)
	$"VBoxContainer/Volume Control2".changed.connect(func n(value): UserSettings.song_volume = value)
	$"VBoxContainer/Volume Control3".changed.connect(func n(value): UserSettings.sfx_volume = value)

func process_box():
	for box in boxes:
		box.scale = Vector2(1, 1)
		box.enabled = false
	
	boxes[selected].scale = Vector2(1.05, 1.05)
	boxes[selected].enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_t = (t + int(delta * 1000)) % 1500
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
