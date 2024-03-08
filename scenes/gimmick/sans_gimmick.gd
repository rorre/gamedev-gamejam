extends Node
class_name SansGimmick

const gap = 1000.0/30.0 # Run gimmicks interpolation in 30 FPS
const gap_s = gap / 1000.0
const ONE_BEAT_MS: float = 230.769230769231

var rng = RandomNumberGenerator.new()
var noise_y = 0

class Tick:
	var value: float
	var time: int
	
	func _init(t: int, v: float):
		value = v
		time = t

func generate_linear_ticks(start_t: int, from: float, end: float, duration: int):
	var ticks: Array[Tick] = []
	var total_ticks = ceil(duration / gap)
	var delta = (end - from) / total_ticks
	for i in range(total_ticks):
		var value = from + delta * i
		var t = int(start_t + gap * i)
		ticks.append(Tick.new(t, value))
	
	return ticks

func move_wave(start_t: int, from: float, end: float, duration: int, minus: bool = false, y_scale: float = 1.0):
	var commands: Array[MoveWindow] = []
	var ticks = generate_linear_ticks(start_t, from, end, duration)
	for t in ticks:
		var x = t.value * 0.2 + 0.4
		var y = sin(t.value * 2 * PI) / 4 * y_scale
		if minus:
			y = y * -1
		commands.append(
			MoveWindow.new(t.time, x, 0.5 + y, gap_s)
		)
	return commands

func generate_shake(t: int):
	var DELTA_SHAKE = 0.0025
	var commands: Array[MoveWindow] = []
	
	for i in range(2):
		noise_y += 2
		var delta_x = rng.randf_range(-DELTA_SHAKE, DELTA_SHAKE)
		var delta_y = rng.randf_range(-DELTA_SHAKE, DELTA_SHAKE)
		commands.append(
			MoveWindow.new(t + gap * i, 0.5 + delta_x, 0.5 + delta_y, gap_s / 2)
		)
	
	commands.append(
		MoveWindow.new(t + gap * 2, 0.5, 0.5, gap_s / 2)
	)
	return commands

func generate_breathe(start_t: int, end_t: int):
	var commands: Array[MoveWindow] = []
	
	while start_t < end_t:
		commands.append(MoveWindow.new(start_t, 0.5, 0.45, ONE_BEAT_MS * 8 / 1000))
		start_t += ONE_BEAT_MS * 8
		if start_t >= end_t:
			break
		
		commands.append(MoveWindow.new(start_t, 0.5, 0.5, ONE_BEAT_MS * 8 / 1000))
		start_t += ONE_BEAT_MS * 8
		if start_t >= end_t:
			break

		commands.append(MoveWindow.new(start_t, 0.5, 0.55, ONE_BEAT_MS * 8 / 1000))
		start_t += ONE_BEAT_MS * 8
		if start_t >= end_t:
			break

		commands.append(MoveWindow.new(start_t, 0.5, 0.5, ONE_BEAT_MS * 8 / 1000))
		start_t += ONE_BEAT_MS * 8
		if start_t >= end_t:
			break
	return commands

var gimmicks: Array[Command]
func _init():
	randomize()
	rng.seed = randi()
	
	gimmicks = [
		MoveWindow.new(ONE_BEAT_MS, 0.4, 0.5, ONE_BEAT_MS / 2 / 1000)
	]
	gimmicks.append(ChangeSpeed.new(3411, 0.5, ONE_BEAT_MS * 4 * 4 / 1000))
	gimmicks.append_array(move_wave(3411, 0, 1, 1846, false, 0.25))
	gimmicks.append_array(move_wave(5257, 1, 0, 1846, true, 0.25))
	gimmicks.append_array(move_wave(7103, 0, 1, 1846, false, 0.25))
	gimmicks.append_array(move_wave(8949, 1, 0.5, 1800, true, 0.25))
	gimmicks.append(MoveWindow.new(10795, 0.5, 0.4, 5.521 / 2))
	gimmicks.append(ChangeSpeed.new(10795, 1.0, ONE_BEAT_MS * 4 * 4 / 1000))
	gimmicks.append(MoveWindow.new(13556, 0.5, 0.5, 5.521 / 2))
	
	for i in range(18392, 47700, ONE_BEAT_MS * 2):
		gimmicks.append_array(generate_shake(i))
	
	for i in range(47700, 61546, ONE_BEAT_MS):
		gimmicks.append_array(generate_shake(i))

	gimmicks.append(ChangeSpeed.new(62469, 0.5, ONE_BEAT_MS * 4 / 1000))
	gimmicks.append_array(generate_breathe(62469, 102162))
	gimmicks.append(ChangeSpeed.new(104941, 1, ONE_BEAT_MS * 4 / 1000))
	gimmicks.append(MoveWindow.new(104941, 0.5, 0.55, ONE_BEAT_MS / 4 / 1000))
	gimmicks.append(MoveWindow.new(105277, 0.45, 0.5, ONE_BEAT_MS / 4 / 1000))
	gimmicks.append(MoveWindow.new(105623, 0.5, 0.45, ONE_BEAT_MS / 4 / 1000))
	gimmicks.append(MoveWindow.new(105969, 0.55, 0.5, ONE_BEAT_MS / 4 / 1000))
	gimmicks.append(MoveWindow.new(106316, 0.5, 0.55, ONE_BEAT_MS / 4 / 1000))
	gimmicks.append(MoveWindow.new(106777, 0.5, 0.5, ONE_BEAT_MS / 4 / 1000))
	
	for i in range(107008, 121316, ONE_BEAT_MS * 2):
		gimmicks.append_array(generate_shake(i))
	
	gimmicks.append(MoveWindow.new(121546, 0.1, 0.5, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(122931, 0.5, 0.5, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(123392, 0.9, 0.5, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(124777, 0.5, 0.5, ONE_BEAT_MS / 2 / 1000))
	
	gimmicks.append(MoveWindow.new(125239, 0.45, 0.55, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(125700, 0.5, 0.6, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(126162, 0.55, 0.55, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(126623, 0.5, 0.5, ONE_BEAT_MS / 2 / 1000))
	
	gimmicks.append(MoveWindow.new(127085, 0.45, 0.45, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(127546, 0.5, 0.4, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(128008, 0.55, 0.45, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(128469, 0.5, 0.5, ONE_BEAT_MS / 2 / 1000))
	
	gimmicks.append(MoveWindow.new(128931, 0.5, 0.45, ONE_BEAT_MS * 8 / 1000))
	
	gimmicks.append(MoveWindow.new(135392, 0.45, 0.5, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(135392 + ONE_BEAT_MS, 0.5, 0.45, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(135392 + ONE_BEAT_MS * 2, 0.55, 0.5, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(135392 + ONE_BEAT_MS * 3, 0.5, 0.45, ONE_BEAT_MS / 2 / 1000))
	
	gimmicks.append(MoveWindow.new(135392 + ONE_BEAT_MS * 4, 0.45, 0.5, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(135392 + ONE_BEAT_MS * 5, 0.5, 0.45, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(135392 + ONE_BEAT_MS * 6, 0.55, 0.5, ONE_BEAT_MS / 2 / 1000))
	gimmicks.append(MoveWindow.new(135392 + ONE_BEAT_MS * 7, 0.5, 0.45, ONE_BEAT_MS / 2 / 1000))
	
	gimmicks.append(MoveWindow.new(137239, 0.5, 0.5, ONE_BEAT_MS / 2 / 1000))
	
	for i in range(137469, 162854, ONE_BEAT_MS * 2):
		gimmicks.append_array(generate_shake(i))
	
	for i in range(163085, 166777, ONE_BEAT_MS):
		gimmicks.append_array(generate_shake(i))
	
	gimmicks.append(MoveWindow.new(166777, 0.5, 1.25, ONE_BEAT_MS * 14 * 4 / 1000))
	gimmicks.append(ChangeSpeed.new(166777, 0.25, ONE_BEAT_MS * 14 * 4 / 1000))	

func cleanup(window: Window):
	await MoveWindow.new(181546, 0.5, 0.5, ONE_BEAT_MS / 2 / 1000).run(window)
	ChangeSpeed.new(104941, 1, ONE_BEAT_MS / 2 / 1000).run(window)
	

func on_time_change(window: Window, t: int):
	if not gimmicks:
		return

	var first = gimmicks[0]
	if t >= gimmicks[0].time:
		gimmicks.pop_front()
		first.run(window)
