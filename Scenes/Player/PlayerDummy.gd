extends "res://Scenes/Player/Player.gd"

export(String) var start_state

func _ready():
	$stateMachine.change_state(start_state)
