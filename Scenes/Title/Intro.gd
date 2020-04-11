extends Control

export(String, FILE, "*.tscn") var next_scene

func _ready():
	#Globals.set("title", get_tree().edited_scene_root.filename)
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	TransitionMgr.transitionTo(next_scene)
