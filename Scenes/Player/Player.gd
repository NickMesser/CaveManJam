extends KinematicBody2D

export var player_speed = 2
var flipped = false

var motion = Vector2.ZERO
var facing = "right"

func _ready():
	Globals.set("player", self)
	
func get_state():
	return $stateMachine.current_state.name

# Movement

func face_mouse():
	var mouse_pos = get_local_mouse_position()
	if mouse_pos == Vector2.ZERO:
		facing = "down"
		return
	if abs(mouse_pos.x) > abs(mouse_pos.y):
		if sign(mouse_pos.x) == 1:
			facing = "right"
			$Sprite.flip_h = false
		else:
			facing = "left"
			$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
		if sign(mouse_pos.y) == 1:
			facing = "down"
		else:
			facing = "up"

func process_movement(delta):
	var target_speed = Vector2()
	if Input.is_action_pressed("move_up"):
		target_speed.y -= player_speed
	if Input.is_action_pressed("move_down"):
		target_speed.y += player_speed
	if Input.is_action_pressed("move_left"):
		target_speed.x -= player_speed
	if Input.is_action_pressed("move_right"):
		target_speed.x += player_speed
	motion = target_speed.normalized() * player_speed
	if motion.x > 0:
		$Sprite.flip_h = false
	elif motion.x < 0:
		$Sprite.flip_h = true

func process_move_and_collide(delta):
	var collision_data = move_and_collide(motion)
	return collision_data

# Sound and Animation

func play_walk_sound(playing : bool):
	if playing:
		if not $Footsteps.is_playing():
			$Footsteps.play()
	else:
		$Footsteps.stop()

func play_anim(action):
	if $anim.get_current_animation() != action:
		$anim.play(action)

func stop_anim(frame : int):
	$anim.stop()
	$Sprite.frame = frame

func anim_playing():
	return $anim.is_playing()
