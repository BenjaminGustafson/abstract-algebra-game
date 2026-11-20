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

# Names an element as r^k (front) or r^k s (flipped), from its pose
func label(e) -> String:
	var p := pose_of(e)
	var k := roundi(p[0] / (TAU / n))  # rotation count, 0..n-1
	var rot := "e" if k == 0 else "r" if k == 1 else "r^%d" % k
	if p[1] > 0:
		return rot
	return "s" if k == 0 else rot + "s"  # flipped elements get an s suffix

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
var flip_axis := 0.0  # screen angle of the line the current flip pivots on

func _vertex(i: int, r: float) -> Vector2:
	var a := TAU * i / n
	return r * Vector2(sin(a), -cos(a))

func _draw() -> void:
	super._draw()  # dark background and border from Group
	# Pose transform: rotate to flip_axis, squash by flipx, rotate back, then apply the pose
	var xf := Transform2D(flip_axis, Vector2(size.x / 2, 70)).scaled_local(Vector2(flipx, 1)) \
		* Transform2D(angle - flip_axis, Vector2.ZERO).scaled_local(Vector2(sx, 1))
	draw_set_transform_matrix(xf)
	var pts := PackedVector2Array()
	for i in n:
		pts.append(_vertex(i, 45))
	draw_colored_polygon(pts, Color.RED if sx * flipx > 0 else Color.BLUE)  # red front, blue back
	pts.append(pts[0])  # close the outline
	draw_polyline(pts, Color.WHITE)
	# Labels: same pose transform, but glyphs are rasterized at zoomed size
	# and the basis is divided by z to cancel the node's scale (origin stays put)
	var z := get_global_transform().get_scale().x
	draw_set_transform_matrix(Transform2D(xf.x / z, xf.y / z, xf.origin))
	for i in n:
		draw_string(ThemeDB.fallback_font, (_vertex(i, 30) + Vector2(-4, 5)) * z,
			str(i + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, roundi(16 * z))


func pose_of(p: Permutation) -> Array:
	var k := p.row.find(1)
	var front := p.row.find(2) == (k + 1) % n
	return [k * TAU / n, 1.0 if front else -1.0]

func set_current(e) -> void:
	var pose := pose_of(e)
	var t := create_tween()
	var duration := 0.2
	if pose[1] != sx:
		flip_axis = (pose[0] + angle) / 2.0  # the mirror line that takes the old pose to the new one
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
