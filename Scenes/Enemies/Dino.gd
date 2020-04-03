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
