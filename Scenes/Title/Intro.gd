extends Control

export(String, FILE, "*.tscn") var next_scene

func _on_AnimationPlayer_animation_finished(anim_name):
	TransitionMgr.transitionTo(next_scene)
