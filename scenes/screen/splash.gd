extends Control

var current_showing: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await transition_to($Developer).finished
	await get_tree().create_timer(0.5).timeout
	await transition_to($Fasilkom).finished
	await get_tree().create_timer(0.5).timeout
	await transition_to($Attributions).finished
	await get_tree().create_timer(0.5).timeout
	await transition_to($Title).finished

func transition_to(new_control: Control):
	var tween = create_tween()
	if current_showing:
		tween.tween_property(current_showing, "modulate:a", 0, 1)
	tween.tween_property(new_control, "modulate:a", 1, 1)
	current_showing = new_control
	
	return tween
