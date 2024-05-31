class_name Pathfinder
extends Node

const DEFAULT_LAYER = 0

var _tilemap: TileMap
var _astar: AStar2D
var _cell_ids: Dictionary = {}


func initialize(tilemap: TileMap):
	_tilemap = tilemap
	_astar = AStar2D.new()
	_setup_astar()


func calculate_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	var path := PackedVector2Array()
	var from_cell: Vector2i = _tilemap.local_to_map(from)
	var to_cell: Vector2i = _tilemap.local_to_map(to)
	if from_cell in _cell_ids and to_cell in _cell_ids:
		path = _astar.get_point_path(_cell_ids[from_cell], _cell_ids[to_cell])
		path.remove_at(0)
	if path.is_empty():
		print("Pathfinder :: calculate_path :: Cannot calculate path from [", from, "]", " to [", to, "]")
	return path
	

func _setup_astar():
	_add_points()
	_connect_points()


func _add_points():	
	var cells: Array[Vector2i] = _tilemap.get_used_cells(DEFAULT_LAYER).filter(_is_walkable_cell)
	var id: int = 0
	for cell in cells:
		_cell_ids[cell] = id
		_astar.add_point(id, cell)
		id += 1
		

func _connect_points():
	var cells: Array[Vector2i] = _tilemap.get_used_cells(DEFAULT_LAYER).filter(_is_walkable_cell)
	for cell in cells:
		var neighbors := _get_walkable_neighbor_cells(cell)
		neighbors = neighbors.filter(
			func(neighbor): return neighbor in cells)
		for neighbor in neighbors:
			_astar.connect_points(_cell_ids[cell], _cell_ids[neighbor])


func _get_neighbor_cells(cell: Vector2i) -> Array:
	var cell_position: Vector2 = _tilemap.map_to_local(cell)
	var tile_size: Vector2 = _tilemap.tile_set.tile_size
	var half_tile_size: Vector2 = _tilemap.tile_set.tile_size / 2
	var neighbors: Array = [
		Vector2(cell_position.x + tile_size.x, cell_position.y),
		Vector2(cell_position.x - tile_size.x, cell_position.y),
		Vector2(cell_position.x, cell_position.y + tile_size.y),
		Vector2(cell_position.x, cell_position.y - tile_size.y),
		Vector2(cell_position.x + half_tile_size.x, cell_position.y + half_tile_size.y),
		Vector2(cell_position.x - half_tile_size.x, cell_position.y + half_tile_size.y),
		Vector2(cell_position.x + half_tile_size.x, cell_position.y - half_tile_size.y),
		Vector2(cell_position.x - half_tile_size.x, cell_position.y - half_tile_size.y),
	]
	neighbors = neighbors.map(func(neighbor): return _tilemap.local_to_map(neighbor))
	return neighbors

func _is_walkable_cell(cell: Vector2i) -> bool:
	var tile_data = _tilemap.get_cell_tile_data( DEFAULT_LAYER, cell )
	return tile_data != null and tile_data.get_custom_data("walkable")

func _get_walkable_neighbor_cells(cell: Vector2i) -> Array:
	return _get_neighbor_cells(cell).filter(_is_walkable_cell)
