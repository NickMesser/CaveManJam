extends AudioStreamPlayer

export(String, DIR) var PATH
var sound_list = []

var smash1 = load("res://Assets/Sounds/Smash/smash1.wav")
var smash2 = load("res://Assets/Sounds/Smash/smash2.wav")
var smash3 = load("res://Assets/Sounds/Smash/smash3.wav")
var smash4 = load("res://Assets/Sounds/Smash/smash4.wav")
var smash5 = load("res://Assets/Sounds/Smash/smash5.wav")
var smash6 = load("res://Assets/Sounds/Smash/smash6.wav")

func _ready():
	sound_list = [smash1, smash2, smash3, smash4, smash5, smash6]
	if sound_list.empty(): return
	var random_pick = randi() % sound_list.size()
	var sound = sound_list[random_pick]
	set_stream(sound) 

func get_sounds(path : String):
	var sounds = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".wav"):
			var full_path = path + "/" + file
			#var sound = load(full_path)
			sounds.append(load(full_path))
	dir.list_dir_end()
	return sounds
