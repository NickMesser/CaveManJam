extends AudioStreamPlayer

export(String, DIR) var PATH
var sound_list = []

func _ready():
	sound_list = get_sounds(PATH)
	var random_pick = randi() % sound_list.size()
	var sound = load(sound_list[random_pick])
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
			sounds.append(full_path)
	dir.list_dir_end()
	return sounds
