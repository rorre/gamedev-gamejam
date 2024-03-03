extends Command
class_name MoveWindow

var x: float
var y: float
var duration: float

func _init(t: int, x_percent: float, y_percent: float, length: float):
	super(t)
	x = x_percent
	y = y_percent
	duration = length

func run(window: Window):
	var start = Time.get_unix_time_from_system()
	var screen_size = DisplayServer.screen_get_size()
	var start_pos = window.position
	var final_x = screen_size.x * x
	var final_y = screen_size.y * y
	while true:
		var curr = Time.get_unix_time_from_system()
		var value = lerp(0.0, 1.0, (curr - start) / duration)
		
		var window_size = window.size
		var new_x = final_x - (window_size.x / 2)
		var new_y = final_y - (window_size.y / 2)
		
		var delta = Vector2i(new_x, new_y) - start_pos
		window.position = start_pos + Vector2i(delta * value)
		if value >= 1.0:
			return
		await window.get_tree().create_timer(1/60).timeout
