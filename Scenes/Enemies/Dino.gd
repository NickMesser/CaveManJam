extends KinematicBody2D

const ARRIVE_DIST = 2.0

var speed = 1.5
var velocity = Vector2.ZERO

var facing = "right"
var move_destination : Vector2

var path = []
var path_step = 0

func _ready():
	path = Globals.get("current_scene").get_nav(position, move_destination)
	#get move dest
	#start roaming
	pass

func start():
	$stateMachine.change_state("roaming")

func stop():
	$stateMachine.change_state("waiting")

func get_new_path():
	move_destination = Globals.get("current_scene").get_random_point()
	path = Globals.get("current_scene").get_nav(position, move_destination)
	while(path.size() <= 2):
		print(path)
		move_destination = Globals.get("current_scene").get_random_point()
		path = Globals.get("current_scene").get_nav(position, move_destination)
	path_step = 0
	
func process_move_and_collide(delta):
	var collision_data = move_and_collide(velocity, true, true, true)
	if collision_data:
		get_new_path()
	else:
		collision_data = move_and_collide(velocity)
	return collision_data

func process_movement(delta):
	velocity = velocity.normalized() * speed
	if velocity.x > 0:
		$Sprite.flip_h = false
	elif velocity.x < 0:
		$Sprite.flip_h = true

func play_anim(action):
	if $anim.get_current_animation() != action:
		$anim.play(action)

func anim_playing():
	return $anim.is_playing()

func face_player_and_bite():
	var player_pos = Globals.get("player").global_position - global_position
	print(player_pos)
	if player_pos == Vector2.ZERO:
		facing = "down"
		play_anim("bite_down")
		return
	if abs(player_pos.x) > abs(player_pos.y):
		if sign(player_pos.x) == 1:
			facing = "right"
			$Sprite.flip_h = false
			play_anim("bite_side")
		else:
			facing = "left"
			$Sprite.flip_h = true
			play_anim("bite_side")
	else:
		$Sprite.flip_h = false
		if sign(player_pos.y) == 1:
			facing = "down"
			play_anim("bite_down")
		else:
			facing = "up"
			play_anim("bite_up")
	Globals.get("player").anim_lock("die")

func _on_hit_box_body_entered(body):
	$stateMachine.change_state("biting")
