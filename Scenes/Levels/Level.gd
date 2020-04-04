extends Node2D


var notification_scene = preload("res://Scenes/Notification/Notification.tscn")
var item_scene = preload("res://Scenes/Items/Item.tscn")

var items = []

func _ready():
	SignalMgr.register_subscriber(self, "notify", "notify")
	Globals.set("current_scene", self)
	randomize()
	init_items()
	

func _input(event):
	if event.is_action_released("pause"):
		if get_tree().paused:
			$UI/Collection.hide()
			get_tree().paused = false
		else:
			get_tree().paused = true
			$UI/Collection.show()

func notify(pos : Vector2, text : String, color : Color = Color.white):
	var notification = notification_scene.instance()
	notification.notify(pos, text)
	notification.set_color(color)
	add_child(notification)

# ITEMS #

func init_items():
	for i in range(16):
		items.append(i)
	items.shuffle()

func get_random_item():
	var item = items.pop_back()
	return item

func spawn_item(id, pos):
	var new_item = item_scene.instance()
	new_item.frame = id
	new_item.global_position = pos
	$RandomMapGenerator/Items.add_child(new_item)

func pickup_item(id):
	$UI/Collection.reveal_item(id)

func _on_RandomMapGenerator_map_done():
	#$RandomMapGenerator.place_items()
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
