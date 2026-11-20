class_name WireHookup
extends Node2D

const RADIUS := 5.0  # screen-space radius at zoom 1
var hovered := false  # true while the cursor is over the circle
var hit_size := Vector2.ZERO  # hover area, centered on the dot; set by the list
var wiring := false  # true while a wire is being dragged from this hookup
var partner: WireHookup  # other end of the permanent wire, or null

func _init(pos: Vector2) -> void:
	position = pos
	set_notify_transform(true)  # so we hear about zoom changes from ancestors
	add_to_group("hookups")  # lets a dragged hookup find the others on release
	z_as_relative = false  # z values are absolute, so nesting depth can't change draw order

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		queue_redraw()  # circle size depends on zoom

func _draw() -> void:
	# Same trick as the dots: rasterize at zoomed size, cancel the node's scale
	var z := get_global_transform().get_scale().x
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE / z)
	draw_circle(Vector2.ZERO, RADIUS * z, Color.YELLOW if hovered else Color.GREEN if partner else Color.WHITE, true, -1.0, true)
	if wiring:
		var e := get_local_mouse_position() * z  # cursor, in the zoomed drawing space
		draw_polyline(Wire.curve(e), Color.YELLOW, 1.5 * z, true)  # same curve as permanent wires

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var over := Rect2(-hit_size / 2, hit_size).has_point(get_local_mouse_position())  # strip beside the button
		if over != hovered:
			hovered = over
			queue_redraw()  # only redraw when the state flips
		if wiring:
			queue_redraw()  # wire end follows the cursor
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if wiring and not event.pressed:
			_connect_to_hovered()
		wiring = event.pressed and hovered and partner == null  # a connected hookup can't start a new wire		z_index = 1 if wiring else 0  # draw above other groups while wiring
		if wiring:
			get_viewport().set_input_as_handled()  # don't also start a group drag
		queue_redraw()
	z_index = 2 if wiring else 0  # temp wire draws above permanent wires (1) and groups (0)

# On release: pair with the hovered free hookup, if any
func _connect_to_hovered() -> void:
	for h in get_tree().get_nodes_in_group("hookups"):
		if h != self and h.hovered and h.partner == null:
			partner = h
			h.partner = self
			add_child(Wire.new(h))  # permanent wire, drawn from this dot to h's
			h.queue_redraw()  # partner's color changes too
			return
