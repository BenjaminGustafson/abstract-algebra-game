class_name Wire
extends Node2D

var end: WireHookup  # far end; this node is a child of the near end

# Bezier points from the origin to e, with horizontal tangents at both ends
static func curve(e: Vector2) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for k in 21:
		pts.append(Vector2.ZERO.bezier_interpolate(Vector2(e.x / 2, 0), Vector2(e.x / 2, e.y), e, k / 20.0))
	return pts

func _init(e: WireHookup) -> void:
	end = e
	z_index = 1  # draw above groups, like the temporary wire
	z_as_relative = false  # absolute z = 1, above groups at 0

func _process(_delta: float) -> void:
	queue_redraw()  # groups can move at any time, so redraw every frame

func _draw() -> void:
	var z := get_global_transform().get_scale().x
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE / z)  # crisp at any zoom, as in WireHookup
	draw_polyline(curve(to_local(end.global_position) * z), Color.GREEN, 1.5 * z, true)
