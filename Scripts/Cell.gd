@tool
class_name Cell
extends Object

static var WIDTH: int = 32
static var DEPTH: int = 16
static var HALF_WIDTH: int = int(WIDTH / 2.0)
static var HALF_DEPTH: int = int(DEPTH / 2.0)

@export var id: int = 0
@export var world_coordinate: Vector2 = Vector2(0, 0)
@export var pixel_coordinate: Vector2 = Vector2(0, 0)

var _world: World
var _shape: PackedVector2Array
var _walkable: bool

func _init(world: World, _i: int, _j: int):
  _world = world
  world_coordinate =                      Vector2(_i, _j)
  pixel_coordinate = World.world_to_pixel(Vector2(_i, _j))
  id = _world._at(_i, _j)

  _walkable = randf() < 0.7

func i() -> int  : return int(world_coordinate.x)
func j() -> int  : return int(world_coordinate.y)
func x() -> float: return pixel_coordinate.x
func y() -> float: return pixel_coordinate.y

func _init_shape() -> void:
  _shape = PackedVector2Array()
  _shape.push_back(World.world_to_pixel(world_coordinate + Vector2(0, 0)))
  _shape.push_back(World.world_to_pixel(world_coordinate + Vector2(0, 1)))
  _shape.push_back(World.world_to_pixel(world_coordinate + Vector2(1, 1)))
  _shape.push_back(World.world_to_pixel(world_coordinate + Vector2(1, 0)))

func _draw(node: Node2D) -> void:
  if !_shape: _init_shape()
  if _walkable:
    node.draw_colored_polygon(_shape, Color.GREEN)
  else:
    node.draw_colored_polygon(_shape, Color.RED  )
  # if (i() + j()) & 1:
  #   node.draw_colored_polygon(_shape, Color.MAGENTA)
  # else:
  #   node.draw_colored_polygon(_shape, Color.BLACK  )