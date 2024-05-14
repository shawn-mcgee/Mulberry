extends Node2D


var _pathfinder: Pathfinder
@onready var _tilemap: TileMap = $TileMap 
@onready var _villager: CharacterBody2D = $Villager 


func _ready():
	_pathfinder = Pathfinder.new()
	_pathfinder.initialize(_tilemap)


func _process(delta):
	if not _villager.moving and Input.is_action_just_pressed("left_click"):
		var path := _pathfinder.calculate_path(_villager.position, _get_clicked_tile_center())
		for point in path:
			_villager.move_to(_tilemap.map_to_local(point))
			await _villager.moved


func _get_clicked_tile_center():
	return get_local_mouse_position().snapped(_tilemap.tile_set.tile_size / 2)
