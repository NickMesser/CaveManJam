extends Node2D

var next_scene = null

func _ready():
	next_scene = get_tree().get_root().get_child(3).get("next_scene")
	print(next_scene)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		if next_scene:
			TransitionMgr.transitionTo(next_scene)
