class_name Automaton
extends Node

@onready var _world   : World    = get_parent().get_parent().get_parent()
@onready var _villager: Villager = get_parent().get_parent()
@onready var _automata: Automata = get_parent()

var _task: Task = null

func __on_cancel__() -> void: Objects.invoke(self, "_on_cancel")

func __on_start__() -> void: Objects.invoke(self, "_on_start")
func __on_resume__() -> void: Objects.invoke(self, "_on_resume")
func __on_suspend__() -> void: Objects.invoke(self, "_on_suspend")
func __on_complete__() -> void: Objects.invoke(self, "_on_complete")

static func _new(task: Task) -> Automaton:
  if task is NavigationTask: return NavigationAutomaton.new(task)
  # elif task is ...: return ...
  # elif task is ...: return ...
  else:
    printerr("[Automaton._new] Failed to create automaton for task ", task)
    return null