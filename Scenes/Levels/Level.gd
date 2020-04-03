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
	
func next_level():
	$LoadingMap.show()
	$RandomMapGenerator.clear_map()

func get_nav(pointA, PointB):
	return $RandomMapGenerator.get_nav(pointA, PointB)

func get_random_point():
	return $RandomMapGenerator.get_random_walkable_position()
