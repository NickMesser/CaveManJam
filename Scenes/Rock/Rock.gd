extends Node2D

signal rock_smashed(pos)

var smashed = false
var HP = 3

var item : int
var has_item = false

func _ready():
	SignalMgr.register_publisher(self, "rock_smashed")

func set_item(id : int):
	item = id
	has_item = true

func get_item():
	return item

func smash():
	if HP > 0:
		HP -= 1
		$Smash.play()
		play_smash_anim()

func play_smash_anim():
	if HP == 2:
		play_anim("smash1")
	elif HP == 1:
		play_anim("smash2")
	else:
		play_anim("destroy")

#change this to the visual animation later
func _on_Smash_finished():
	queue_free()

func play_anim(action):
	if $anim.get_current_animation() != action:
		$anim.play(action)

func _on_anim_animation_finished(anim_name):
	if anim_name == "destroy":
		emit_signal("rock_smashed", global_position)
		if get_item():
			Globals.get("current_scene").spawn_item(get_item(), global_position)
		queue_free()
