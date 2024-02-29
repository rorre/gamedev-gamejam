extends Node

signal speed_change(new_speed: int)
signal master_volume_change(value: int)
signal song_volume_change(value: int)
signal sfx_volume_change(value: int)

@onready var master_bus_idx = AudioServer.get_bus_index("Master")
@onready var sfx_bus_idx = AudioServer.get_bus_index("SFX")
@onready var song_bus_idx = AudioServer.get_bus_index("Song")

@export var speed: int = 5:
	set(new_speed):
		speed = new_speed
		ms_window = 50 * (20 - speed)
		speed_change.emit(new_speed)
@export var master_volume: int = 50:
	set(value):
		master_volume_change.emit(value)
		AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(value / 100.0))
		master_volume = value
@export var song_volume: int = 50:
	set(value):
		song_volume_change.emit(value)
		AudioServer.set_bus_volume_db(song_bus_idx, linear_to_db(value / 100.0))		
		song_volume = value
@export var sfx_volume: int = 50:
	set(value):
		sfx_volume_change.emit(value)
		AudioServer.set_bus_volume_db(sfx_bus_idx, -6 + linear_to_db(value / 100.0))		
		sfx_volume = value


var ms_window = 50 * (20 - speed)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_volume = 50
	song_volume = 50
	sfx_volume = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("speed_up"):
		speed = min(speed + 1, 20)
	elif Input.is_action_just_pressed("speed_down"):
		speed = max(speed - 1, 0)

