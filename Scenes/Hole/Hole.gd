extends Node2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		var player = Globals.get("player")
		player.z_index = 1
		$Tween.interpolate_property(player, "global_position", player.global_position, self.global_position, 0.3, Tween.TRANS_EXPO, Tween.EASE_IN)
		$Tween.start()
		player.anim_lock("down_hole")
		Globals.get("current_scene").next_level()
