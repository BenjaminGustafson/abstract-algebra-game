class_name Workspace
extends Node2D

const ZOOM_MIN := 1.0
const ZOOM_MAX := 4.0
const ZOOM_STEP := 1.1  # scale factor per wheel notch
const CELL := 40

var cells := Vector2i(40, 25)  # 40x25 cells keeps the area at 800x500 px
var panning := false  # true while right mouse button is held

var content := Node2D.new()  # holds zoom/offset; groups will be its children

var dragged: Group  # group currently held, or null
var grab := Vector2.ZERO  # cursor offset from the group's origin



func _init() -> void:
	add_child(content)

func _ready() -> void:
	get_viewport().size_changed.connect(_clamp)
	var view := get_viewport_rect().size
	# Start at the middle of the clamp range, so there's equal slack on every side
	content.position = (view - Vector2(cells * CELL) * content.scale.x) / 2


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		panning = event.pressed
	elif event is InputEventMouseButton and event.pressed and event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
		_zoom(ZOOM_STEP if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1 / ZOOM_STEP)
	elif event is InputEventMouseMotion and panning:
		content.position += event.relative  # pan the content, not the workspace
		_clamp()


func _draw() -> void:
	var t := content.transform  # grid points go through this; shapes stay unscaled
	var r := 1.5 * t.get_scale().x  # dot radius grows with zoom
	for x in range(cells.x + 1):
		for y in range(cells.y + 1):
			draw_circle(t * (Vector2(x, y) * CELL), r, Color.WHITE, true, -1.0, true)
	#draw_rect(Rect2(t.origin, Vector2(cells * CELL) * t.get_scale().x), Color.WHITE, false)


func _zoom(factor: float) -> void:
	var before := content.get_local_mouse_position()  # grid point under the cursor
	content.scale = Vector2.ONE * clampf(content.scale.x * factor, ZOOM_MIN, ZOOM_MAX)
	# After scaling, that point has drifted; shift content to put it back
	content.position += (content.get_local_mouse_position() - before) * content.scale.x
	_clamp()  # keep the view inside the grid; also redraws
	
func _clamp() -> void:
	var view := get_viewport_rect().size
	var grid := (Vector2(cells)+Vector2(2,2)) * CELL * content.scale.x  # grid size on screen
	# Corner must stay in [view - grid, 0] so the view never leaves the grid
	content.position = content.position.clamp(view - grid, Vector2(0,0))
	queue_redraw()  # dots are drawn through content's transform

# _unhandled_input so buttons inside a group get clicks first
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragged = _group_at(content.get_local_mouse_position()) if event.pressed else null
		if dragged:
			grab = content.get_local_mouse_position() - dragged.position
	elif event is InputEventMouseMotion and dragged:
		var cell := ((content.get_local_mouse_position() - grab) / CELL).round()  # snap to grid
		var limit := Vector2(cells * CELL) - dragged.size  # keep inside the border
		dragged.position = (cell * CELL).clamp(Vector2.ZERO, limit)

func _group_at(p: Vector2) -> Group:
	var kids := content.get_children()
	kids.reverse()  # topmost (last added) first
	for c in kids:
		if c is Group and Rect2(c.position, c.size).has_point(p):
			return c
	return null
