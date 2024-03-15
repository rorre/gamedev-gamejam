extends Node
class_name AlephGimmick

const ONE_BEAT = 240.0 / 1000;

var gimmicks = [
	ChangeSpeed.new(6696, 4, ONE_BEAT / 8),
	ChangeSpeed.new(7656, 1, 0.2),
	ChangeSpeed.new(18241, 4, ONE_BEAT / 8),
	ChangeSpeed.new(18481, 1, ONE_BEAT / 2),
	ChangeSpeed.new(26881, 0.5, ONE_BEAT),
	ChangeSpeed.new(37166, 1, 3.429),
	ChangeSpeed.new(41452, 4, ONE_BEAT / 8),
	ChangeSpeed.new(43166, 0.5, 3.918),
	ChangeSpeed.new(47084, 1, 24.84),
	ChangeSpeed.new(77712, 0.5, 2.4),
	ChangeSpeed.new(80112, 1, 1),
	ChangeSpeed.new(82752, 0.1, 0.1),
	ChangeSpeed.new(83712, 1, 0.1),
	ChangeSpeed.new(84672, 0.1, 0.1),
	ChangeSpeed.new(85152, 1, 0.1),
	ChangeSpeed.new(86599, 0.1, 0.1),
	ChangeSpeed.new(87552, 1, 0.1),
	ChangeSpeed.new(88512, 0.1, 0.1),
	ChangeSpeed.new(88992, 1, 0.1),
	ChangeSpeed.new(89712, 0.01, 0.05),
	ChangeSpeed.new(89772, 1, 1.86),
	ChangeSpeed.new(91632, 0.01, 0.05),
	ChangeSpeed.new(91692, 1, 1.86),
	ChangeSpeed.new(93552, 0.2, ONE_BEAT * 4 * 2),
	ChangeSpeed.new(106992, 1, ONE_BEAT * 4),
	ChangeSpeed.new(110832, 0.25, 0.1),
	ChangeSpeed.new(111792, 1, 0.1),
	ChangeSpeed.new(115632, 0.25, 0.1),
	ChangeSpeed.new(116592, 1, 0.1),
	ChangeSpeed.new(118512, 0.25, 0.1),
	ChangeSpeed.new(119472, 1, 0.1),
	ChangeSpeed.new(123312, 0.25, 0.1),
	ChangeSpeed.new(124272, 0.0000001, 0.1),
	ChangeSpeed.new(131183, 1, 0.768),
]

func cleanup(window: Window):
	ChangeSpeed.new(0, 1, 0.2).run(window)
	

func on_time_change(window: Window, t: int):
	if not gimmicks:
		return

	var first = gimmicks[0]
	if t >= gimmicks[0].time:
		gimmicks.pop_front()
		first.run(window)
