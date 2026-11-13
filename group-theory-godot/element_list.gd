class_name ElementList
extends Node2D

var group: Group
var elements: Array  # canonical order, supplied by the caller
var found := {}      # slot index -> true once discovered

func _init(g: Group, elems: Array) -> void:
	group = g
	elements = elems
	g.state_changed.connect(_on_state_changed)
	_on_state_changed(g.current)

func _on_state_changed(e) -> void:
	for i in elements.size():
		if group.same(elements[i], e):
			found[i] = true
	queue_redraw()

func _draw() -> void:
	for i in elements.size():
		if found.has(i):
			draw_string(ThemeDB.fallback_font, Vector2(0, 20 * i + 16), group.label(elements[i]))
