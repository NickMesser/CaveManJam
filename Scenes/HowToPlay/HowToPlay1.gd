extends Control

export(String, FILE, "*.tscn") var next_scene

func _input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		TransitionMgr.transitionTo(next_scene)
