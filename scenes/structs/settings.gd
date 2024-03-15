extends Node

signal speed_change(new_speed: int)
signal master_volume_change(value: int)
signal song_volume_change(value: int)
signal sfx_volume_change(value: int)

const CONFIG_PATH = "user://config.ini"

@onready var master_bus_idx = AudioServer.get_bus_index("Master")
@onready var sfx_bus_idx = AudioServer.get_bus_index("SFX")
@onready var song_bus_idx = AudioServer.get_bus_index("Song")

var effective_speed: float = 1.0:
	get:
		return speed * speed_multiplier

@export var speed_multiplier: float = 1.0:
	set(new_speed):
		speed_multiplier = new_speed
		speed_change.emit(effective_speed)

@export var speed: int = 1:
	set(new_speed):
		speed = new_speed
		speed_change.emit(effective_speed)
		config.set_value("settings", "speed", new_speed)
		config.save(CONFIG_PATH)

@export var master_volume: int = 50:
	set(value):
		master_volume_change.emit(value)
		AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(value / 100.0))
		master_volume = value
		config.set_value("settings", "master_volume", value)
		config.save(CONFIG_PATH)

@export var song_volume: int = 50:
	set(value):
		song_volume_change.emit(value)
		AudioServer.set_bus_volume_db(song_bus_idx, linear_to_db(value / 100.0))		
		song_volume = value
		config.set_value("settings", "song_volume", value)
		config.save(CONFIG_PATH)

@export var sfx_volume: int = 50:
	set(value):
		sfx_volume_change.emit(value)
		AudioServer.set_bus_volume_db(sfx_bus_idx, -6 + linear_to_db(value / 100.0))		
		sfx_volume = value
		config.set_value("settings", "sfx_volume", value)
		config.save(CONFIG_PATH)

var config: ConfigFile
var ms_window = max((1.5 - log(effective_speed) / log(5)) * 1000, 0.033):
	get:
		return max((2.0 - log(effective_speed) / log(5)) * 1000, 0.033)

func _ready() -> void:
	config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err == OK:
		master_volume = config.get_value("settings", "master_volume", 50)
		song_volume = config.get_value("settings", "song_volume", 50)
		sfx_volume = config.get_value("settings", "sfx_volume", 50)
		speed = config.get_value("settings", "speed", 1)
	else:
		master_volume = 50
		song_volume = 50
		sfx_volume = 50
		speed = 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("speed_up"):
		speed = clamp(speed + 1, 1, 20)
	if Input.is_action_just_pressed("speed_down"):
		speed = clamp(speed - 1, 1, 20)
