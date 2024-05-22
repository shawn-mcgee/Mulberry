class_name Automata
extends RefCounted

var _villager: Villager
var _stack   : Array[Automaton] = [ ]

func stack_push(task: Task) -> void:
  var automaton = Automata._new(task)
  automaton._villager = _villager
  automaton._automata = self
  automaton._task     = task
  _stack.push_front(automaton)

  automaton.__on_init__()

func stack_pop (          ) -> void:
  _stack.pop_front()

func suspend() -> void:
  if _stack.front():
    _stack.front().__on_suspend__()

func resume() -> void:
  if _stack.front():
    _stack.front().__on_resume__()

func cancel() -> void:
  if _stack.front():
    _stack.front().__on_cancel__()

func step() -> void:
  if _stack.front():
    _stack.front().__on_step__()
  
static func _new(task: Task) -> Automaton:
  if task is NavigationTask: return NavigationAutomaton.new()
  # elif task is ...: return ...
  # elif task is ...: return ...
  else: return null

# serialize automata
static func   to_array(a: Automata) -> Array[Task]:
  var array: Array[Task] = [ ]
  for automaton in a._stack:
    array.append(automaton._task)
  return array

# deserialize automata
static func from_array(a: Array[Task]) -> Automata:
  var automata = Automata.new()
  for task in a:
    automata.stack_push( task )
  return automata