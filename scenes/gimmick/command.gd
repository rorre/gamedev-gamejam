extends Node
class_name Command

var time: int

func _init(t: int):
	time = t

func run(window: Window):
	assert(false, "This is meant to be overriden")
