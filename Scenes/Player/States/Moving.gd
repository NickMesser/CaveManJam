extends "res://Scenes/StateMachine/baseState.gd"

const IDLE_DOWN = 12
const IDLE_UP = 44
const IDLE_SIDE = 18

func update(delta):
	if Input.is_action_just_pressed("mouse_click"):
		change_state("smashing")
		return
	# idle
	if host.motion == Vector2.ZERO:
		var frame = IDLE_DOWN
		host.play_walk_sound(false)
		if host.facing == "down":
			frame = IDLE_DOWN
		elif host.facing == "up":
			frame = IDLE_UP
		else:
			frame = IDLE_SIDE
		host.stop_anim(frame)
	# side movement
	elif abs(host.motion.x) >= abs(host.motion.y):
		#side anim
		if sign(host.motion.x) > 0:
			#face right
			host.facing = "right"
		elif sign(host.motion.x) < 0:
			host.facing = "left"
		host.play_anim("walk_side")
		host.play_walk_sound(true)
	# vertical movement
	elif abs(host.motion.y) > abs(host.motion.x):
		if sign(host.motion.y) > 0:
			host.facing = "down"
			host.play_anim("walk_down")
		elif sign(host.motion.y) < 0:
			host.facing = "up"
			host.play_anim("walk_up")
		host.play_walk_sound(true)
	host.process_movement(delta)
	host.process_move_and_collide(delta)
