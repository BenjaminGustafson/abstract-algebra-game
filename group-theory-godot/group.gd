class_name Group
extends Node2D

signal state_changed(element)

var size := Vector2(200, 120)
var current

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false)

func set_current(e) -> void:
	current = e
	queue_redraw()
	state_changed.emit(e)

func same(a, b) -> bool: return a == b
func label(e) -> String: return str(e)
