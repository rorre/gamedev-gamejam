extends Node

class_name Difficulty

@export var rating: String
@export var chart: String
@export var color: Color


static func parse_json(diff: Variant):
	var obj = new()
	obj.rating = diff["rating"]
	obj.chart = diff["chart"]
	obj.color = diff["color"]
	return obj
