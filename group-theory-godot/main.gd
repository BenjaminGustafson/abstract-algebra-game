extends Node2D

var filled := false

func _draw():
	draw_rect(Rect2(50, 50, 200, 100), Color.WHITE, filled)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		filled = not filled
		queue_redraw()
