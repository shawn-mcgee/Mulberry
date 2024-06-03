class_name Villager
extends CharacterBody2D


@export var speed: float = 2.5 # cells per second


@onready var _automata: Automata = $Automata

var _selected: bool = false

func _on_acquire() -> void:
  _selected = true
  queue_redraw()

func _on_release() -> void:
  _selected = false
  queue_redraw()

func _draw():
  if _selected:
    draw_arc(to_local(position), 12, 0, TAU, 32, Color.ORANGE)
