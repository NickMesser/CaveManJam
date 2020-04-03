extends Node2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		Globals.get("player").anim_lock("down_hole")
		Globals.get("current_scene").next_level()
