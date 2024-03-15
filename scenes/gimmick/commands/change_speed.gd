extends Command
class_name ChangeSpeed

var speed_change: float
var duration: float
var settings: UserSettings

func _init(t: int, speed_multiplier: float, length: float):
	super(t)
	speed_change = speed_multiplier
	duration = length

func run(window: Window) -> Tween:
	if not settings:
		settings = window.get_node("/root/UserSettings")
		
	var tween = window.create_tween()
	tween.tween_property(
		settings,
		"speed_multiplier",
		speed_change,
		duration
	)
	tween.play()

	return tween
