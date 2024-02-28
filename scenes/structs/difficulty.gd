extends Node

class_name Difficulty

@export var rating: String
@export var chart: String


static func parse_json(diff: Variant):
	var obj = new()
	obj.rating = diff["rating"]
	obj.chart = diff["chart"]
	return obj
