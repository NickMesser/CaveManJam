extends Position2D

var tilemap

var player

func _ready():
	tilemap = get_tree().get_root().find_node("TileMap", true, false)
	player = get_tree().get_root().find_node("Player", true, false)

func _physics_process(delta):	
	if tilemap:
		var mousePos = get_global_mouse_position()
		var tile = tilemap.world_to_map(mousePos)
		var newPos = tilemap.map_to_world(Vector2(tile.x, tile.y))
		newPos.x += 16
		newPos.y += 16
		self.position = newPos
