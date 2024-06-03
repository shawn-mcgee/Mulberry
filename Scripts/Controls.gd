extends Node

var _world     : World

var _selection_anchor = null
var _selection_handle = null
var _selection        = [  ]

func _ready():
	_world = get_parent()

func _select_at(a: Vector2           ) -> Array:
	var q = PhysicsPointQueryParameters2D.new()
	q.collide_with_areas  = true
	q.collide_with_bodies = true
	q.position = a

	# select one thing
	for result in _world.get_world_2d().direct_space_state.intersect_point(q):
		if (
			result.collider is Villager # or
		# result.collider is ...        or
		# result.collider is ...
		):
			return [ result.collider ]
	return [ ]

func _select_in(a: Vector2, b: Vector2) -> Array:
	#TODO: select all things in bounds
	return [ ]

func _input(event):	
	if event is InputEventMouseMotion:
		if event.is_pressed()  and event.button_index == MOUSE_BUTTON_LEFT:
			if not _selection_anchor: return
			_selection_handle = _world.make_input_local(event).position

	if event is InputEventMouseButton:
		if event.is_pressed()  and event.button_index == MOUSE_BUTTON_LEFT:
			_selection_anchor = _world.make_input_local(event).position
			_selection_handle = null
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			_release_all(_selection)
			_selection   .   clear()
			if _selection_handle:
				_selection = _select_in(_selection_anchor, _selection_handle)
			else                : 
				_selection = _select_at(_selection_anchor                   )			
			_selection_anchor = null
			_selection_handle = null
			_acquire_all(_selection)

		if event.is_pressed()  and event.button_index == MOUSE_BUTTON_RIGHT:
			if not _selection: return
			
			var object = _select_at(_world.make_input_local(event).position)

			if not object:
				var position = _world.make_input_local(event).position
				for subject in _selection:
					if subject is Villager:
						var task := NavigationTask.new()
						task.from = World.pixel_to_world(subject.position)
						task.to   = World.pixel_to_world(        position)
						task.path = _world.calculate_path(task.from, task.to)
						subject._automata.cancel()
						subject._automata.stack_push(task)

func _acquire(a: Object) -> void:
	Objects.invoke(a, "_on_acquire")

func _release(a: Object) -> void:
	Objects.invoke(a, "_on_release")

func _acquire_all(a: Array) -> void:
	for i in a: _acquire(i)

func _release_all(a: Array) -> void:
	for i in a: _release(i)
