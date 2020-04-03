extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.play_anim(host.cur_anim)

func update(delta):
	if not host.anim_playing():
		change_state("moving")
