@tool
class_name World
extends Node2D

static var NORTH = Vector2( 0, -1)
static var WEST  = Vector2(-1,  0)
static var SOUTH = Vector2( 0,  1)
static var EAST  = Vector2( 1,  0)

static var NORTHWEST = NORTH + WEST
static var SOUTHWEST = SOUTH + WEST
static var SOUTHEAST = SOUTH + EAST
static var NORTHEAST = NORTH + EAST

@export var debug: bool = false:
	set(value):
		debug = value
		queue_redraw()

@export var width: int = 0:
	set(value):
		width = value
		_init_cells()
		queue_redraw()

@export var depth: int = 0:
	set(value):
		depth = value
		_init_cells()
		queue_redraw()

var _cells: Array[Cell] = [ ]
var _astar: AStar2D

func _ready():
	_init_cells()
	_init_astar()

func _init_cells() -> void:
	_cells.resize(width * depth)
	for i in range(width):
		for j in range(depth):
			_cells[_at(i, j)] = Cell.new(self, i, j)
	# force starting area to be walkable
	if width > 2 and depth > 2:
		_cells[_at(0, 0)]._walkable = true
		_cells[_at(1, 0)]._walkable = true
		_cells[_at(0, 1)]._walkable = true
		_cells[_at(1, 1)]._walkable = true

func _init_astar() -> void:
	_astar = AStar2D.new()
	_init_astar_points()
	_join_astar_points()

func _init_astar_points() -> void:
	for cell in _cells:
		_astar.add_point(cell.id, cell.world_coordinate + Vector2(0.5, 0.5))

func _join_astar_points() -> void:
	for cell in _cells:
		if cell._walkable:
			for neighbor in walkable_neighbors_of(cell):
				if neighbor._walkable:
					_astar.connect_points(cell.id, neighbor.id)

func cell_at(i: int, j: int) -> Cell:
	return _cells[_at(i, j)] if _has(i, j) else null

func cell_at_world(world: Vector2) -> Cell:
	return cell_at(
		int(world.x), 
		int(world.y)
	)

func cell_at_pixel(pixel: Vector2) -> Cell:
	return cell_at_world(World.pixel_to_world(pixel))

func walkable_neighbors_at(i: int, j: int) -> Array:
	var north     = cell_at(i,     j - 1)
	var west      = cell_at(i - 1, j    )
	var south     = cell_at(i,     j + 1)
	var east      = cell_at(i + 1, j    )
	# fix to prevent pathing through corners
	var northwest = cell_at(i - 1, j - 1) if (north and north._walkable) and (west and west._walkable) else null
	var southwest = cell_at(i - 1, j + 1) if (south and south._walkable) and (west and west._walkable) else null
	var southeast = cell_at(i + 1, j + 1) if (south and south._walkable) and (east and east._walkable) else null
	var northeast = cell_at(i + 1, j - 1) if (north and north._walkable) and (east and east._walkable) else null

	return [
		north, northwest,
		west , southwest,
		south, southeast,
		east , northeast
	].filter(func(c): return c != null)

func walkable_neighbors_at_world(world: Vector2) -> Array:
	var i: int = int(world.x)
	var j: int = int(world.y)
	return walkable_neighbors_at(i, j)

func walkable_neighbors_at_pixel(pixel: Vector2) -> Array:
	return walkable_neighbors_at_world(World.pixel_to_world(pixel))

func walkable_neighbors_of(cell: Cell) -> Array:
	return walkable_neighbors_at(
		cell.i(),
		cell.j()
	)

# calculate a path in world coordinates
func calculate_path(a: Vector2, b: Vector2) -> PackedVector2Array:
	var src := cell_at_world(a)
	var dst := cell_at_world(b)

	if not src or not dst:
		if not src: printerr("[World.calculate_path] src cell at ", a, " does not exist.")
		if not dst: printerr("[World.calculate_path] dst cell at ", b, " does not exist.")
		return PackedVector2Array()

	var path := _astar.get_point_path(src.id, dst.id)

	if not path:
		printerr("[World.calculate_path] dst cell at ", b, " is unreachable from src cell at ", a, ".")
		return PackedVector2Array()
	
	if path.size() > 1:
		path.remove_at(path.size() - 1)
		path.remove_at(              0)
		path.push_back(b)
		
	return path

func _at (i: int, j: int) -> int :
	return j * width + i

func _has(i: int, j: int) -> bool:
	return (
		i >= 0 and i < width and
		j >= 0 and j < depth
	)

static func world_to_pixel(world: Vector2) -> Vector2:
	return Vector2(
		(world.x - world.y) * Cell.HALF_WIDTH,
		(world.x + world.y) * Cell.HALF_DEPTH
	)

static func pixel_to_world(pixel: Vector2) -> Vector2:
	var x = pixel.x / Cell.WIDTH
	var y = pixel.y / Cell.DEPTH
	return Vector2(
		y + x,
		y - x
	)

func _draw():
	if debug:
		for cell in _cells:
			cell._draw(self)
