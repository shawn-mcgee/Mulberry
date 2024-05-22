class_name Automaton
extends RefCounted

var _villager: Villager
var _automata: Automata
var _task: Task

# called once when pushed onto the stack
func __on_init__() -> void:
  Objects.invoke(self, "_on_init")

# called every "tick"
func __on_step__() -> void:
  Objects.invoke(self, "_on_step")

# called when automata is suspended
func __on_suspend__() -> void:
  Objects.invoke(self, "_on_suspend")

# called when automata is resumed
func __on_resume__() -> void: 
  Objects.invoke(self, "_on_resume")

# called when automata is cancelled
func __on_cancel__() -> void:
  Objects.invoke(self, "_on_cancel")