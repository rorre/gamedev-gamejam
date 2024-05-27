extends Node

signal on_cheat_toggled(cheat_name: String, value: bool)

var cheat_state = {
	"hidden": false
}
var cheats = {
	"ILOVEHIDDEN": "hidden"
}
var keycode_stack: Array[String] = []

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			keycode_stack.push_front(OS.get_keycode_string(event.keycode))
			while len(keycode_stack) >= 20:
				keycode_stack.pop_back()
			check_cheat()

func check_cheat():
	for code in cheats:
		var reversed_code = code.reverse()
		if ''.join(keycode_stack).begins_with(reversed_code):
			var cheat_name = cheats[code]
			cheat_state[cheat_name] = not cheat_state[cheat_name]
			on_cheat_toggled.emit(cheat_name, cheat_state[cheat_name])
			
			print(cheat_name + " triggered!")
