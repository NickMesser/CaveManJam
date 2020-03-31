extends Area2D

var player

func _ready():
	set_process_input(true)
	#player = get_tree().get_root().find_node("Player", true, false)
	player = Globals.get("player")
	
func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_click"):
		if not player:
			player = Globals.get("player")
		var distance = self.global_position.distance_to(player.global_position)
		
		if distance < 50:
			get_parent().smash()
