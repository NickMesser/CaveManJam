extends Control

export(String, FILE, "*.tscn") var next_scene

func _input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		$PlayerDummy.get_node("stateMachine").change_state("dummyHole")
		$Tween.interpolate_property($PlayerDummy, "position", $PlayerDummy.position, $Hole.position, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
		yield($Tween, "tween_completed")
		TransitionMgr.transitionTo(next_scene)
