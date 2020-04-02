extends Node2D

signal map_done()

const CAVE_TILE = 47

onready var Map = $LevelTiles
onready var Navmap = $nav/navmap
onready var FoliageMap = $Foliage

var Room = preload("res://Scenes/RandomMapGenerator/Room.tscn")
var Player = preload("res://Scenes/Player/Player.tscn")
var Rock = preload("res://Scenes/Rock/Rock.tscn")
var Hole = preload("res://Scenes/Hole/Hole.tscn")
var Dino = preload("res://Scenes/Enemies/Dino.tscn")

var tile_size = 32
export var num_rooms = 30
var min_size = 5
var max_size = 8
var h_spread = 0

var spawned_rocks = []

var path

export var debug_mode = false

var player = null
var start_room = null
var end_room = null

# goes up .1 every level. more dinos
var difficulty = 3

func _ready():
	SignalMgr.register_subscriber(self, "rock_smashed", "_on_rock_smashed")
	randomize()
	make_rooms()

func _process(delta):
	update()

func _draw():
	if debug_mode:
		for room in $Rooms.get_children():
			draw_rect(Rect2(room.position - room.size, room.size * 2), Color(32, 238,0), false)
		
		if path:
			for p in path.get_points():
				for c in path.get_point_connections(p):
					var pp = path.get_point_position(p)
					var cp = path.get_point_position(c)
					draw_line(pp, cp, Color(1, 1, 0), 15, true)
	
func _input(event):
	if debug_mode:
		if event.is_action_pressed("ui_select"):
			clear_map()
		
		if event.is_action_pressed("ui_focus_next"):
			player = Player.instance()
			add_child(player)
			player.position = start_room.position
	
func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(rand_range(-h_spread, h_spread), 0)
		var r = Room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
		
	yield(get_tree().create_timer(1), 'timeout')
	
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < .2:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector2(room.position.x, room.position.y))
	
	yield(get_tree(), "idle_frame")
	path = find_mst(room_positions)
	make_map()
		
func find_mst(nodes):
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_distance = INF
		var min_position = null
		var current_position = null
		
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			for p2 in nodes:
				if p1.distance_to(p2) < min_distance:
					min_distance = p1.distance_to(p2)
					min_position = p2
					current_position = p1
					
		var n = path.get_available_point_id()
		path.add_point(n, min_position)
		path.connect_points(path.get_closest_point(current_position), n)
		nodes.erase(min_position)
	
	return path
	
func make_map():
	Map.clear()
	find_start_room()
		
	var hallways = []
	#Set room tiles. 
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var pos = Map.world_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				Map.set_cell(ul.x + x, ul.y + y, CAVE_TILE)
				Map.update_bitmask_area(Vector2(ul.x + x, ul.y + y))
				Navmap.set_cell(ul.x + x, ul.y+y, 0)
				var rand = randf()
				if room.position != start_room.position:
					#Spawn_Rocks
					if rand > .9:
						var x_pos = ul.x + x
						var y_pos = ul.y + y
						#Navmap.set_cell(x_pos, y_pos, -1)
						spawn_rock(x_pos, y_pos)
					#Spawn_Foliage
					elif rand > .7:
						var x_pos = ul.x + x
						var y_pos = ul.y + y
						spawn_foliage(x_pos, y_pos)
		
		#Set Hallways
		var p = path.get_closest_point(room.position)
		for connection in path.get_point_connections(p):
			if not connection in hallways:
				var start = Map.world_to_map(path.get_point_position(p))
				var end = Map.world_to_map(path.get_point_position(connection))
				carve_path(start, end)	
		hallways.append(p)
	remove_navs()
	spawn_player()
	spawn_hole()
	spawn_dinos()
	
	emit_signal("map_done")
	
func carve_path(pos1, pos2):
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1, randi() % 2)
	if y_diff == 0: y_diff = pow(-1, randi() % 2)
	
	var x_y = pos1
	var y_x = pos2
	
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y, CAVE_TILE)
		Map.set_cell(x, x_y.y + y_diff, CAVE_TILE)
		Map.update_bitmask_area(Vector2(x, x_y.y))
		Map.update_bitmask_area(Vector2(x, x_y.y + y_diff))
		Navmap.set_cell(x, x_y.y, 0)
		Navmap.set_cell(x, x_y.y + y_diff, 0)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, CAVE_TILE)	
		Map.set_cell(y_x.x + x_diff, y, CAVE_TILE)
		Map.update_bitmask_area(Vector2(y_x.x, y))
		Map.update_bitmask_area(Vector2(y_x.x + x_diff, y))
		Navmap.set_cell(y_x.x, y, 0)
		Navmap.set_cell(y_x.x + x_diff, y, 0)
	
func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

func spawn_player():
	if !player:
		player = Player.instance()
		add_child(player)
		
	player.position = start_room.position

func spawn_hole():
	var random_number = rand_range(0, spawned_rocks.size())
	var new_hole = Hole.instance()
	add_child(new_hole)
	new_hole.position = spawned_rocks[random_number].position
	
func spawn_rock(x_pos, y_pos):
	Navmap.set_cell(x_pos, y_pos, -1)
	var rock = Rock.instance()
	$Rocks.add_child(rock)
	var current_tile = Map.map_to_world(Vector2(x_pos, y_pos))
	current_tile.x += 16
	current_tile.y += 16
	rock.position = current_tile
	spawned_rocks.append(rock)
	
	
func spawn_foliage(x_pos, y_pos):
	var foliage_numbers = [4, 5]
	var rand = rand_range(0, foliage_numbers.size())
	FoliageMap.set_cell(x_pos, y_pos, foliage_numbers[rand])

func spawn_dinos():
	var rooms = $Rooms.get_children()
	for i in range(difficulty):
		var rand = randi() % rooms.size()
		var room = rooms[rand]
		var new_dino = Dino.instance()
		var pos = room.position + (room.size / 2.0)
		new_dino.set_position(pos)
		new_dino.move_destination = new_dino.position
		$Dinos.add_child(new_dino)

func clear_map():
	$Foliage.clear()
	$LevelTiles.clear()
	Navmap.clear()
	spawned_rocks.clear()
	for rock in $Rocks.get_children():
		rock.queue_free()
		
	path = null
	$Hole.queue_free()
	
	for room in $Rooms.get_children():
		room.queue_free()
	
	make_rooms()

func _on_rock_smashed(pos : Vector2):
	var tile_pos = Map.world_to_map(pos)
	Navmap.set_cellv(tile_pos, 0)
	
func remove_navs():
	for rock in $Rocks.get_children():
		var tile_pos = Map.world_to_map(rock.position)
		Navmap.set_cellv(tile_pos, -1)

func get_random_walkable_position():
	var walkables = Navmap.get_used_cells_by_id(0)
	var index = randi() % walkables.size()
	var offset = Navmap.cell_size / 2.0
	var t_pos = walkables[index]
	var pos = Navmap.map_to_world(t_pos) + offset
	return pos

func get_nav(pointA, pointB):
	#first get closest nav points
	#var offset = $map/nav/navMap.get_cell_size() / 2.0
	var start = pointA
	pointA = $nav.get_closest_point(pointA)
	var destination = pointB
	pointB = $nav.get_closest_point(pointB)
	var path = $nav.get_simple_path(pointA, pointB, false)
	if destination != pointB:
		path.append(destination)
	# center the points
	for point in path:
		var t_pos = $nav/navmap.world_to_map(point)
		var offset = $nav/navmap.cell_size / 2.0
		point = $nav/navmap.map_to_world(t_pos) + offset
	#print(path)
	return path
	
