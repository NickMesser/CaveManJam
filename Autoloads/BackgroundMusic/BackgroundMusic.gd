extends Node

signal fade_finished()

const VOLUME = -2.0
const MIN_VOLUME = -80.0

var main_menu = preload("res://Assets/Sounds/Music/Main_Menu_2_-_Audio.wav")
var first_loop = preload("res://Assets/Sounds/Music/SmashSmash_Main_Theme_First_Version.ogg")
var loop = preload("res://Assets/Sounds/Music/SmashSmash_Main_Theme_Loop_Version.ogg")

var looping = false

func fade_in(duration = 1.0):
	$Tween.interpolate_property($music, "volume_db", MIN_VOLUME, VOLUME, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func fade_out(duration = 1.0):
	$Tween.interpolate_property($music, "volume_db", VOLUME, MIN_VOLUME, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func play_main_menu():
	fade_out()
	looping = false
	$music.stream = main_menu
	$music.play()
	fade_in(0.5)

func play_loop():
	fade_out(2.0)
	$music.stream = first_loop
	$music.play()
	looping = true
	fade_in(2.0)

func _on_music_finished():
	if looping:
		$music.stream = loop
		$music.play()
		looping = false
