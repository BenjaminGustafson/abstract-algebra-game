class_name DihedralGroup
extends Group

var n: int

var buttons := []

func _init(degree: int) -> void:
	n = degree
	current = Permutation.new(range(1, n + 1))
	size = Vector2(200, 200)

func _ready() -> void:
	var names := ["rotate", "flip"]
	var gens := _gens()
	set_process(false)
	for i in 2:
		var b := Button.new()
		b.text = names[i]
		b.position = Vector2(size.x * (i + 1) / 3 - 25, size.y - 50)
		b.pressed.connect(func(): set_current(gens[i].then(current)))
		add_child(b)
		buttons.append(b)

func same(a, b) -> bool: return a.equals(b)
func label(e) -> String: return e.cycle_label()

func _gens() -> Array:
	return [Permutation.new([n] + range(1, n)), Permutation.new([1] + range(n, 1, -1))]

func elements() -> Array:
	var r: Permutation = _gens()[0]
	var s: Permutation = _gens()[1]
	var out := []
	var p := Permutation.new(range(1, n + 1))
	for k in n:
		out.append(p)
		out.append(p.then(s))
		p = p.then(r)
	return out

var angle := 0.0  # clockwise rotation, radians
var sx := 1.0     # 1 = front, -1 = back (mirrored)
var flipx := 1.0  # screen-space mirror, only used during a flip

func _vertex(i: int, r: float) -> Vector2:
	var a := TAU * i / n
	return r * Vector2(sin(a), -cos(a))

func _draw() -> void:
	super._draw()
	draw_set_transform_matrix(Transform2D(0, Vector2(size.x / 2, 70))
		.scaled_local(Vector2(flipx, 1)) * Transform2D(angle, Vector2.ZERO)
		.scaled_local(Vector2(sx, 1)))
	var pts := PackedVector2Array()
	for i in n:
		pts.append(_vertex(i, 45))
	draw_colored_polygon(pts, Color.RED if sx * flipx > 0 else Color.BLUE)
	for i in n:
		draw_string(ThemeDB.fallback_font, _vertex(i, 30) + Vector2(-4, 5), str(i + 1))
	pts.append(pts[0])
	draw_polyline(pts, Color.WHITE)
	

func pose_of(p: Permutation) -> Array:
	var k := p.row.find(1)
	var front := p.row.find(2) == (k + 1) % n
	return [k * TAU / n, 1.0 if front else -1.0]

func set_current(e) -> void:
	var pose := pose_of(e)
	var t := create_tween()
	var duration := 0.2
	if pose[1] != sx:
		t.tween_property(self, "flipx", -1.0, duration)
		t.tween_callback(_land.bind(pose))
	else:
		t.tween_property(self, "angle", angle + wrapf(pose[0] - angle, -PI, PI), duration)
	t.tween_callback(_set_busy.bind(false))
	_set_busy(true)
	super.set_current(e)

func _land(pose: Array) -> void:
	angle = pose[0]
	sx = pose[1]
	flipx = 1.0

func _set_busy(b: bool) -> void:
	set_process(b)
	queue_redraw()
	for x in buttons: x.disabled = b

func _process(_delta: float) -> void:
	queue_redraw()
