extends Node

signal speed_change(new_speed: int)


@export var speed: int = 5
var ms_window = 50 * (20 - speed)

func set_speed(new_speed: int):
	speed = new_speed
	ms_window = 50 * (20 - speed)
	speed_change.emit(new_speed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("speed_up"):
		set_speed(min(speed + 1, 20))
	elif Input.is_action_just_pressed("speed_down"):
		set_speed(max(speed - 1, 0))
