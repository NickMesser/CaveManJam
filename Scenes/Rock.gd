extends Area2D

var player

func _ready():
	set_process_input(true)
	player = get_tree().get_root().find_node("Player", true, false)
	
func _input_event(viewport, event, shape_idx):
	if event.is_action("mouse_click"):
		var distance = self.global_position.distance_to(player.global_position)
		
		if distance < 50:
			get_parent().queue_free()
