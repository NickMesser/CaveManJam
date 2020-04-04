extends Node2D

signal notify()

"""
items

type (int)
name (string)
description (string)

fruit, bone, gem, pet rock
fox, meat, shroom1, shroom2
orb, fire, beetle, shell
skull, leaf, fish, lightning
"""

var names = ["Fruit", "Bone", "Gem", "Pet Rock", "Lucky Fox", "Meat", "Smelly Mushroom", "Tasty Mushroom", "Orb", "Fire", "Beetle", "Shell", "Skull", "Pepper", "Fish", "Lightning"]


var frame = 0

func _ready():
	SignalMgr.register_publisher(self, "notify")
	$Sprite.frame = frame


func _on_pickup_body_entered(body):
	Globals.get("player").play_sound("item")
	var item_name = names[frame]
	emit_signal("notify", global_position, item_name)
	# update inventory
	$Tween.interpolate_property(self, "scale", scale, Vector2.ZERO, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
