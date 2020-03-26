extends Node2D

var notification_scene = preload("res://Scenes/Notification/Notification.tscn")

func _ready():
	SignalMgr.register_subscriber(self, "notify", "notify")
	Globals.set("current_scene", self)
	
func notify(pos : Vector2, text : String, color : Color = Color.white):
	var notification = notification_scene.instance()
	notification.notify(pos, text)
	notification.set_color(color)
	add_child(notification)
