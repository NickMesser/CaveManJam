extends CanvasLayer

func hide():
	$AnimationPlayer.play("fade_out")
	yield($AnimationPlayer, "animation_finished")
	$ColorRect.hide()
	$Label.hide()


func show():
	$ColorRect.show()
	$Label.show()
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("loading")
	

