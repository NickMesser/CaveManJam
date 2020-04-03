extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.face_player_and_bite()

func update(delta):
	if not host.anim_playing():
		change_state("roaming")
