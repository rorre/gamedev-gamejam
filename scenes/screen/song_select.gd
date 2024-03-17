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
			"bpm": [[0, 192]],
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
					"bpm": [[0, 190]],
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
					"bpm": [[0, 260]],
					"jacket": "res://songs/reality_check/jacket.jpg",
					"audio": "res://songs/reality_check/audio.mp3",
					"difficulties": [
						{"rating": "4", "chart": "res://songs/reality_check/beginner.json", "color": beginner },
						{"rating": "9", "chart": "res://songs/reality_check/advanced.json", "color": advanced },
						{"rating": "12", "chart": "res://songs/reality_check/expert.json", "color": expert }
					],
					"gimmick": SansGimmick.new()
				}
			),
		)
		songs.append(
			Song.parse_json(
				{
					"artist": "LeaF",
					"title": "ℵ0",
					"bpm": [
						[936, 62],
[9121, 250],
[11521, 250],
[26881, 70],
[47084, 250],
[47319, 251],
[47558, 252],
[47796, 253],
[48033, 254],
[48269, 255],
[48504, 256],
[48738, 257],
[48971, 258],
[49203, 259],
[49434, 260],
[49664, 261],
[49906, 262],
[50136, 263],
[50363, 264],
[50591, 265],
[50804, 266],
[51029, 267],
[51253, 268],
[51476, 269],
[51699, 270],
[51921, 271],
[52142, 272],
[52362, 273],
[52581, 274],
[52799, 275],
[53017, 276],
[53234, 277],
[53467, 278],
[53682, 279],
[53898, 280],
[54111, 281],
[54309, 282],
[54521, 283],
[54733, 284],
[54944, 285],
[55154, 286],
[55363, 287],
[55572, 288],
[55780, 289],
[55987, 290],
[56193, 291],
[56399, 292],
[56604, 293],
[56831, 294],
[57031, 295],
[57238, 296],
[57437, 297],
[57622, 298],
[57823, 299],
[58023, 300],
[58223, 301],
[58422, 302],
[58620, 303],
[58818, 304],
[59015, 305],
[59212, 306],
[59408, 307],
[59603, 308],
[59797, 309],
[60015, 310],
[60205, 311],
[60376, 312],
[60568, 313],
[60761, 314],
[60952, 315],
[61142, 316],
[61333, 317],
[61522, 318],
[61710, 319],
[61898, 320],
[62085, 321],
[62273, 322],
[62459, 323],
[62644, 324],
[62829, 325],
[63031, 326],
[63214, 327],
[63396, 328],
[63578, 329],
[63753, 330],
[63934, 331],
[64115, 332],
[64295, 333],
[64475, 334],
[64654, 335],
[64833, 336],
[65011, 337],
[65193, 338],
[65370, 339],
[65546, 340],
[65722, 341],
[65898, 342],
[66073, 343],
[66248, 344],
[66422, 345],
[66595, 346],
[66768, 347],
[66940, 348],
[67112, 349],
[67283, 350],
[67454, 351],
[67624, 352],
[67794, 353],
[67969, 354],
[68137, 355],
[68306, 356],
[68476, 357],
[68644, 358],
[68811, 359],
[68979, 360],
[69145, 361],
[69319, 362],
[69484, 363],
[69649, 364],
[69813, 365],
[69981, 366],
[70144, 367],
[70307, 368],
[70470, 369],
[70632, 370],
[70794, 371],
[70955, 372],
[71116, 373],
[71271, 374],
[71432, 375],
[71592, 376],
[71752, 377],
[71924, 378],
[72082, 379],
[72240, 380],
[72397, 381],
[72554, 382],
[72711, 383],
[72867, 384],
[73023, 385],
[73178, 386],
[73333, 387],
[73488, 388],
[73642, 389],
[73796, 390],
[73949, 391],
[74102, 392],
[74255, 393],
[74407, 394],
[74559, 395],
[74710, 396],
[74861, 397],
[75012, 398],
[75162, 399],
[75312, 250],
[80112, 125],
[82032, 250],
[82752, 62],
[83712, 250],
[84672, 62],
[85152, 250],
[86592, 62],
[87552, 250],
[88512, 62],
[88992, 250],
[89712, 250],
[93552, 125],
[108912, 250],
[110832, 62],
[111792, 250],
[115632, 125],
[116592, 250],
[118512, 62],
[119472, 250],
[123312, 125],
[124272, 78],
					],
					"jacket": "res://songs/aleph/jacket.png",
					"audio": "res://songs/aleph/audio.mp3",
					"difficulties": [
						{"rating": "5", "chart": "res://songs/aleph/beginner.json", "color": beginner },
						{"rating": "9", "chart": "res://songs/aleph/advanced.json", "color": advanced },
						{"rating": "11", "chart": "res://songs/aleph/expert.json", "color": expert },
						{"rating": "14", "chart": "res://songs/aleph/master.json", "color": master },
					],
					"gimmick": AlephGimmick.new()
				}
			)
		)
	for song in songs:
		var box: SongBox = song_box.instantiate()
		box.song = song
		$SongsContainer.add_child(box)
		boxes.append(box)

func reorder_boxes():
	const delta_x = 350
	const middle_x = 465
	const middle_y = 360
	var tween = create_tween().set_parallel(true)
	for i in range(len(boxes)):
		var box: Panel = boxes[i]
		var scale_box = 0.9
		if i == selected_idx:
			scale_box = 1.0
		
		var w = 350 * scale_box
		var h = 400 * scale_box
		var x = middle_x + delta_x * (i - selected_idx)
		tween.tween_property(box, "position", Vector2(x, middle_y - (h/2)), 0.5)
		tween.tween_property(box, "scale", Vector2(scale_box, scale_box), 0.5)

	tween.play()
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

	reorder_boxes()
	selected_difficulty = clamp(selected_difficulty, 0, len(songs[selected_idx].difficulties) - 1)
	for box in boxes:
		box.set_diff_idx(clamp(selected_difficulty, 0, len(box.song.difficulties) - 1))
