extends "res://Scenes/StateMachine/baseState.gd"

func update(delta):
	if Input.is_action_just_pressed("smash"):
		change_state("smashing")
		return
	if host.motion == Vector2.ZERO:
		host.play_anim("idle")
	else:
		host.play_anim("walk")
	host.process_movement(delta)
	host.process_move_and_collide(delta)
