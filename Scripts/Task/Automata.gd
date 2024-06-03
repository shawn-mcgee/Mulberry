class_name Automata
extends Node

@onready var _villager: Villager = get_parent()
@onready var _automata: Array    = [          ]

# cancel all tasks
func cancel() -> void:
  for automaton in _automata:
    automaton.__on_cancel__()
    remove_child( automaton )
  _automata.clear()

# suspend current task and start new task
func stack_push(task: Task) -> void:
  # suspend current task
  if _automata.size() > 0:
    _automata.front().__on_suspend__()
    remove_child( _automata.front( ) )

  _automata.push_front(Automaton._new(task))

  # start new task
  if _automata.size() > 0:
    add_child(  _automata.front()  )
    _automata.front().__on_start__()
    
# complete current task and resume previous task
func stack_pop() -> void:
  if _automata.size() > 0:
    _automata.front().__on_complete__()
    remove_child(  _automata.front()  )

  _automata.pop_front()

  if _automata.size() > 0:
    add_child   ( _automata.front() )
    _automata.front().__on_resume__()
    





