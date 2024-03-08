extends MoveWindow
class_name ScaleWindow

const default_w = 1280
const default_h = 720

func run(window: Window) -> Tween:
	var tween = window.create_tween().set_parallel(true)
	
	var new_x = (default_w * x)
	var new_y = (default_h * y)
	
	var orig_center = Vector2i(
		window.position.x + window.size.x / 2,
		window.position.y + window.size.y / 2
	)
	tween.tween_property(window, "size", Vector2i(new_x, new_y), duration)
	tween.tween_method(recenter_window.bind(window, orig_center), 0, 1, duration)
	tween.play()
	
	return tween

func recenter_window(_dontcare: int, window: Window, center: Vector2i):
	var x = center.x - (window.size.x / 2)
	var y = center.y - (window.size.y / 2)
	
	window.position = Vector2i(x, y)
