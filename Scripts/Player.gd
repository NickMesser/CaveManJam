extends KinematicBody2D

export var player_speed = 100

var motion := Vector2()

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		motion.x = player_speed
	elif Input.is_action_pressed("move_left"):
		motion.x = -player_speed
	else:
		motion.x = 0
		
	if Input.is_action_pressed("move_up"):
		motion.y = -player_speed
	elif Input.is_action_pressed("move_down"):
		motion.y = player_speed
	else:
		motion.y = 0
	
	move_and_slide(motion)
