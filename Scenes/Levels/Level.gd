extends Node2D


var notification_scene = preload("res://Scenes/Notification/Notification.tscn")


export(String, FILE, "*.tscn") var next_scene

func _ready():
	SignalMgr.register_subscriber(self, "notify", "notify")
	Globals.set("current_scene", self)
	
	
func notify(pos : Vector2, text : String, color : Color = Color.white):
	var notification = notification_scene.instance()
	notification.notify(pos, text)
	notification.set_color(color)
	add_child(notification)


func _on_RandomMapGenerator_map_done():
	$LoadingMap.hide()
	var player = Globals.get("player")
	player.anim_lock("spawn")
	yield(player.get_node("anim"), "animation_finished")
	for dino in $RandomMapGenerator.get_dinos():
		dino.start()

func next_level():
	for dino in $RandomMapGenerator.get_dinos():
		dino.stop()
	var player = Globals.get("player")
	player.anim_lock("down_hole")
	yield(player.get_node("anim"), "animation_finished")
	$RandomMapGenerator.difficulty += 2
	# COULD PUT LOGIC HERE FOR BEATING GAME
	$LoadingMap.show()
	$RandomMapGenerator.clear_map()

func get_nav(pointA, PointB):
	return $RandomMapGenerator.get_nav(pointA, PointB)

func get_random_point():
	return $RandomMapGenerator.get_random_walkable_position()
