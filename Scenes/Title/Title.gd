extends Control

export(String, FILE, "*.tscn") var next_scene



func _on_Start_button_up():
	BackgroundMusic.play_loop()
	TransitionMgr.transitionTo(next_scene)
