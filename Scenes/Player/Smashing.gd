extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.face_mouse()
	if host.facing == "down":
		host.play_anim("smash_down")
	elif host.facing == "up":
		host.play_anim("smash_up")
	else:
		host.play_anim("smash_side")

func update(delta):
	if not host.anim_playing():
		change_state("moving")
		return
