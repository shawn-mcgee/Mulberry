class_name Villager
extends CharacterBody2D


signal moved()

var moving := false


func move_to(target: Vector2):
	#TODO: Villager needs proper movement code, this tween is just to test pathfinding
	if not moving:
		moving = true
		var tween := get_tree().create_tween().tween_property(self, "position", target, 0.3)
		tween.finished.connect(_on_move_ended)


func _on_move_ended():
	moving = false
	moved.emit()
