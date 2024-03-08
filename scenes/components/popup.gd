extends CanvasLayer

signal accepted()
signal rejected()

@export var text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CenterContainer/Panel/MarginContainer/VBoxContainer/Label.text = text


func _on_no_pressed() -> void:
	rejected.emit()


func _on_yes_pressed() -> void:
	accepted.emit()
