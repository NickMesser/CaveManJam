extends Control

export(String, FILE, "*.tscn") var next_scene
export(String, FILE, "*.tscn") var how_to_scene



func _on_Start_button_up():
	BackgroundMusic.play_loop()
	TransitionMgr.transitionTo(next_scene)


func _on_HowToPlay_button_up():
	TransitionMgr.transitionTo(how_to_scene)
