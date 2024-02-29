extends Panel
class_name VolumeControl

signal changed(value: int)

@export var label: String = ""
@export var value: int = 50:
	set(new_value):
		value = new_value
		slider.value = new_value
		changed.emit(value)
@export var max_value: int = 100
@onready var slider = $MarginContainer/VBoxContainer/HSlider
@export var enabled: bool = false:
	set(value):
		slider.editable = value
		enabled = value

func _ready() -> void:
	enabled = false
	$MarginContainer/VBoxContainer/Label.text = label
	slider.value = value
	slider.max_value = max_value

var ttl = 0.05
func _process(delta: float) -> void:
	if not enabled:
		return
	
	ttl -= delta
	if ttl > 0:
		return
	
	ttl = 0.05
	if Input.is_action_pressed("ui_right"):
		slider.set_value(float(min(slider.value + 1, max_value)))
	elif Input.is_action_pressed("ui_left"):
		slider.value = float(max(slider.value - 1, 0))


func _on_h_slider_value_changed(new_value: float) -> void:
	value = int(new_value)
