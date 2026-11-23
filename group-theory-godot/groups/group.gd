class_name Group
extends Node2D

signal state_changed(element)

var size := Vector2(200, 120)
var current
var overlay := Node2D.new()  # inter-group-only UI; the intra workspace hides it

# Subclasses override _init and _ready, so attach the overlay on entering the tree
func _enter_tree() -> void:
	if overlay.get_parent() == null:
		add_child(overlay)

# Hides inter-group UI while the group is shown inside an intra-group workspace
func enter_interior() -> void:
	overlay.visible = false
	overlay.process_mode = Node.PROCESS_MODE_DISABLED  # hidden hookups would still catch _input

func exit_interior() -> void:
	overlay.visible = true
	overlay.process_mode = Node.PROCESS_MODE_INHERIT

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
