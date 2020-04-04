extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.play_anim("down_hole")

func update(delta):
	if not host.anim_playing():
		host.visible = false
