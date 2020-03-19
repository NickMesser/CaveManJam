extends Node2D


export var mapSize := Vector2()

var tileSet

onready var rock = preload("res://Scenes/Rock.tscn")

func _ready():
	tileSet = $TileMap.tile_set
	generate_map()
	generate_rocks()
	
func generate_map():
	var x = 0
	var y = 0
	
	for x in mapSize.x: # spawn grass tile
		for y in mapSize.y:
			$TileMap.set_cell(x, y, 0)
			
func generate_rocks():
	for x in mapSize.x:
		for y in mapSize.y:
			var randomNumber = randf()
			if randomNumber > .9:
				print("New rock")
				var newRock = rock.instance()
				add_child(newRock)
				var currentTile = $TileMap.map_to_world(Vector2(x, y), false)
				newRock.position = currentTile
