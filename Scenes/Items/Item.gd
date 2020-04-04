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
	var item_name = names[frame]
	emit_signal("notify", global_position, item_name)
	# update inventory
	queue_free()
