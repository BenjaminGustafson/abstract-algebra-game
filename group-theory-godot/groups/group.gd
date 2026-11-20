class_name Group
extends Node2D

signal state_changed(element)

var size := Vector2(200, 120)
var current

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.1, 0.1, 0.1))  # dark background, drawn first
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false)
	
func set_current(e) -> void:
	current = e
	queue_redraw()
	state_changed.emit(e)
	
# Applies element e to the current state; e must provide then() (true for Permutation)
func apply(e) -> void:
	set_current(e.then(current))

func same(a, b) -> bool: return a == b
func label(e) -> String: return str(e)

# Draws text sharp at any zoom: rasterize at zoomed size, then cancel the scale
func draw_text(pos: Vector2, s: String) -> void:
	var z := get_global_transform().get_scale().x
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE / z)
	draw_string(ThemeDB.fallback_font, pos * z, s, HORIZONTAL_ALIGNMENT_LEFT, -1, roundi(16 * z))
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)  # reset for later draws
