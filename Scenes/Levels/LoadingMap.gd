extends CanvasLayer

func hide():
	$AnimationPlayer.stop()
	$ColorRect.hide()
	$Label.hide()

func show():
	$AnimationPlayer.play("loading")
	$ColorRect.show()
	$Label.show()
