extends Node2D

var smashed = false

func smash():
	if not smashed:
		smashed = true
		$Smash.play()
		#also play animation

#change this to the visual animation later
func _on_Smash_finished():
	queue_free()
