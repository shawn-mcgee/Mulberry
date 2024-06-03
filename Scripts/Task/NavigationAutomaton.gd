class_name NavigationAutomaton
extends Automaton


func _init(task: NavigationTask):
  _task = task

func navigation_task() -> NavigationTask:
  return _task as NavigationTask

func _process(delta) -> void:
  if navigation_task().path.size() == 0:
    return _automata.stack_pop()

  var position  = World.pixel_to_world(_villager.position)
  var direction = (navigation_task().path[0] - position).normalized()
  var magnitude = (navigation_task().path[0] - position).length    ()
  position += direction * min(_villager.speed * delta, magnitude)
  
  if position == navigation_task().path[0]:
    navigation_task().path.remove_at(0)

  _villager.position = World.world_to_pixel(position)
