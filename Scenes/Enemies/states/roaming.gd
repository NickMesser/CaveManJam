extends "res://Scenes/StateMachine/baseState.gd"

var move_target : Vector2

func enter():
	move_target = host.path[host.path_step]
	host.velocity = move_target  - host.get_position()

func update(delta):
	if host.get_position().distance_to(move_target) <= host.ARRIVE_DIST:
		host.path_step += 1
		if host.path_step == host.path.size():
			host.get_new_path()
		change_state("roaming")
	# side movement
	if abs(host.velocity.x) >= abs(host.velocity.y):
		#side anim
		if sign(host.velocity.x) > 0:
			#face right
			host.facing = "right"
		elif sign(host.velocity.x) < 0:
			host.facing = "left"
		host.play_anim("move_side")
	# vertical movement
	elif abs(host.velocity.y) > abs(host.velocity.x):
		if sign(host.velocity.y) > 0:
			host.facing = "down"
			host.play_anim("move_down")
		elif sign(host.velocity.y) < 0:
			host.facing = "up"
			host.play_anim("move_up")
	host.process_movement(delta)
	host.process_move_and_collide(delta)
