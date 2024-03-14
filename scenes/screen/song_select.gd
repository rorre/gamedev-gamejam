extends Control

signal song_selected(song: Song, diff: Difficulty)
const beginner = Color("#327832")
const advanced = Color("#b47b1b")
const expert = Color("#a12d29")
const master = Color("#762f9f")
const misc = Color("#1f5e84")

var songs: Array[Song] = [
	Song.parse_json(
		{
			"artist": "iyowa",
			"title": "一千光年",
			"bpm": 192,
			"jacket": "res://songs/issen_kounen/jacket.png",
			"audio": "res://songs/issen_kounen/audio.mp3",
			"difficulties": [
				{"rating": "1", "chart": "res://songs/issen_kounen/beginner.json", "color": beginner },
				{"rating": "5", "chart": "res://songs/issen_kounen/advanced.json", "color": advanced },
			],
			"gimmick": null
		}
	),
	#Song.parse_json(
		#{
			#"artist": "xi",
			#"title": "FREEDOM DiVE",
			#"jacket": "res://songs/fd/jacket.png",
			#"audio": "res://songs/fd/audio.mp3",
			#"difficulties": [{"rating": "15", "chart": "res://songs/fd/master.json", "color": master }],
			#"gimmick": null
		#}
	#)
]

const song_box = preload("res://scenes/components/song_box.tscn")
var selected_idx = 0
var selected_difficulty = 0
var boxes: Array[SongBox] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not OS.has_feature("web"):
		songs[0].difficulties.append_array(
			[
				Difficulty.parse_json({"rating": "8", "chart": "res://songs/issen_kounen/expert.json", "color": expert }),
				Difficulty.parse_json({"rating": "?", "chart": "res://songs/issen_kounen/append.json", "color": misc })
			]
		)
		songs.append(
			Song.parse_json(
				{
					"artist": "ああああ",
					"title": "コドモチック・フィロソフィ",
					"bpm": 190,
					"jacket": "res://songs/childish/jacket.jpg",
					"audio": "res://songs/childish/audio.mp3",
					"difficulties":
					[
						{"rating": "3", "chart": "res://songs/childish/beginner.json", "color": beginner },
						{"rating": "7", "chart": "res://songs/childish/advanced.json", "color": advanced },
						{"rating": "10", "chart": "res://songs/childish/expert.json", "color": expert }
					],
					"gimmick": null
				}
			)
		)
		songs.append(
			Song.parse_json(
				{
					"artist": "DM DOKURO",
					"title": "Reality Check Through The Skull",
					"bpm": 260,
					"jacket": "res://songs/reality_check/jacket.jpg",
					"audio": "res://songs/reality_check/audio.mp3",
					"difficulties": [
						{"rating": "4", "chart": "res://songs/reality_check/beginner.json", "color": beginner },
						{"rating": "9", "chart": "res://songs/reality_check/advanced.json", "color": advanced },
						{"rating": "12", "chart": "res://songs/reality_check/expert.json", "color": expert }
					],
					"gimmick": SansGimmick.new()
				}
			)
		)
	for song in songs:
		var box: SongBox = song_box.instantiate()
		box.song = song
		$SongsContainer/HBoxContainer.add_child(box)
		boxes.append(box)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		selected_idx = clamp(selected_idx + 1, 0, len(songs) - 1)
	elif Input.is_action_just_pressed("ui_left"):
		selected_idx = clamp(selected_idx - 1, 0, len(songs) - 1)
	elif Input.is_action_just_pressed("ui_up"):
		selected_difficulty = selected_difficulty + 1
	elif Input.is_action_just_pressed("ui_down"):
		selected_difficulty = selected_difficulty - 1
	elif Input.is_action_just_pressed("ui_accept"):
		song_selected.emit(
			songs[selected_idx], songs[selected_idx].difficulties[selected_difficulty]
		)

	for box in boxes:
		box.scale = Vector2(1, 1)
	boxes[selected_idx].scale = Vector2(1.05, 1.05)

	selected_difficulty = clamp(selected_difficulty, 0, len(songs[selected_idx].difficulties) - 1)
	for box in boxes:
		box.set_diff_idx(clamp(selected_difficulty, 0, len(box.song.difficulties) - 1))
