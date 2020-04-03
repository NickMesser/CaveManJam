extends Node

func play_sound(sound_name : String):
	var sound = get_node("sound_name")
	if not sound: return
	if not sound.is_playing():
		sound.play()

