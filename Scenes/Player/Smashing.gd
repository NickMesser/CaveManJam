extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.play_anim("smash")

func update(delta):
	if not host.anim_playing():
		change_state("moving")
		return
	host.process_move_and_collide(delta)
