extends Control
class_name Result

@export var song: Song
@export var difficulty: Difficulty
# [miss, good, great, perfect
@export var grades: Array[int]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TopSection/BoxContainer/TextureRect.texture = load(song.jacket)
	$TopSection/Title.text = song.title
	$TopSection/Artist.text = song.artist
	$TopSection/Level.text = "Lv. " + difficulty.rating
	
	$StatsBox/PerfectCount.text = str(grades[3])
	$StatsBox/GreatCount.text = str(grades[2])
	$StatsBox/GoodCount.text = str(grades[1])
	$StatsBox/MissCount.text = str(grades[0])
	
	var sum_notes = grades.reduce(func(acc, e): return acc + e, 0)
	var acc = (grades[3] * 1 + grades[2] * 0.75 + grades[1] * 0.5) / sum_notes * 100
	var rounded = snapped(acc, 0.01)
	$AccuracyBox/Accuracy.text = "%.2f%%" % rounded
	
	if rounded == 100:
		$AccuracyBox/Grade.text = "SS"
	elif rounded > 98:
		$AccuracyBox/Grade.text = "S+"
	elif rounded > 95:
		$AccuracyBox/Grade.text = "S"
	elif rounded > 90:
		$AccuracyBox/Grade.text = "A"
	elif rounded > 80:
		$AccuracyBox/Grade.text = "B"
	elif rounded > 70:
		$AccuracyBox/Grade.text = "C"
	elif rounded > 60:
		$AccuracyBox/Grade.text = "D"
	else:
		$AccuracyBox/Grade.text = "F"
	
