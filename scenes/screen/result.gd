extends Control
class_name Result

@export var song: Song
@export var difficulty: Difficulty
# [miss, good, great, perfect
@export var grades: Array[int]
@export var accuracy: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TopSection/SongDetail.song = song
	$TopSection/SongDetail.difficulty = difficulty
	
	$StatsBox/PerfectCount.text = str(grades[3])
	$StatsBox/GreatCount.text = str(grades[2])
	$StatsBox/GoodCount.text = str(grades[1])
	$StatsBox/MissCount.text = str(grades[0])
	$AccuracyBox/Accuracy.text = "%.2f%%" % accuracy
	
	if accuracy == 100:
		$AccuracyBox/Grade.text = "SS"
	elif accuracy > 98:
		$AccuracyBox/Grade.text = "S+"
	elif accuracy > 95:
		$AccuracyBox/Grade.text = "S"
	elif accuracy > 90:
		$AccuracyBox/Grade.text = "A"
	elif accuracy > 80:
		$AccuracyBox/Grade.text = "B"
	elif accuracy > 70:
		$AccuracyBox/Grade.text = "C"
	elif accuracy > 60:
		$AccuracyBox/Grade.text = "D"
	else:
		$AccuracyBox/Grade.text = "F"
	
