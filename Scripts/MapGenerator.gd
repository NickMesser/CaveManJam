extends Node2D


export var mapSize := Vector2()

onready var rock = preload("res://Scenes/Rock.tscn")

var rocks = Array()

func _ready():
	randomize()
	generate_map()
	generate_rocks()
	generate_hole()
	
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
				var newRock = rock.instance()
				add_child(newRock)
				var currentTile = $TileMap.map_to_world(Vector2(x, y), false)
				currentTile.x += 16
				currentTile.y += 16
				rocks.append(currentTile)
				newRock.position = currentTile
	
func generate_hole():
	var random_rock = rand_range(0, rocks.size())
	print("Hole is located at : " + str(rocks[random_rock]))
	pass
