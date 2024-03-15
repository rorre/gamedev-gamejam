extends Node

class_name Song

#{
#"artist": "ああああ",
#"title": "コドモチック・フィロソフィ",
#"jacket": "res://songs/childish/jacket.jpg",
#"audio": "res://songs/childish/audio.mp3",
#"difficulties": [
#{
#"level": 10,
#"chart": "res://songs/childish/expert.json"
#}
#]
#},

@export var artist: String
@export var title: String
@export var jacket: String
@export var audio: String
@export var difficulties: Array[Difficulty]
@export var gimmick: Node
@export var bpm: Array


static func parse_json(song: Variant) -> Song:
	var obj = new()
	obj.artist = song["artist"]
	obj.title = song["title"]
	obj.jacket = song["jacket"]
	obj.audio = song["audio"]
	obj.bpm = song["bpm"]

	var diffs: Array[Difficulty] = []
	for diff in song["difficulties"]:
		diffs.append(Difficulty.parse_json(diff))

	obj.gimmick = song["gimmick"]
	obj.difficulties = diffs
	return obj
