extends "res://Scenes/StateMachine/baseState.gd"

var counter = 0.0
var TURN_TIME = 1.0

func enter():
	counter = 0.0
	host.motion = Vector2(0.0, 1.0)

func update(delta):
	counter += delta
	if counter > TURN_TIME:
		host.motion = host.motion.rotated(PI/2)
		counter = 0.0
	# side movement
	if abs(host.motion.x) >= abs(host.motion.y):
		#side anim
		if sign(host.motion.x) > 0:
			#face right
			host.facing = "right"
			host.get_node("Sprite").flip_h = false
		elif sign(host.motion.x) < 0:
			host.facing = "left"
			host.get_node("Sprite").flip_h = true
		host.play_anim("walk_side")
		#host.play_walk_sound(true)
	# vertical movement
	elif abs(host.motion.y) > abs(host.motion.x):
		host.get_node("Sprite").flip_h = false
		if sign(host.motion.y) > 0:
			host.facing = "down"
			host.play_anim("walk_down")
		elif sign(host.motion.y) < 0:
			host.facing = "up"
			host.play_anim("walk_up")
		#host.play_walk_sound(true)
	host.process_move_and_collide(delta)
