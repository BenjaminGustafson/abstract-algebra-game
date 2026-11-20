class_name SymmetricGroup
extends Group

var n: int

func _init(degree: int) -> void:
	n = degree
	size = Vector2(5, 5) * Workspace.CELL  # 5x5 cells, so the far edge lands on grid lines
	current = Permutation.new(range(1, n + 1))

func _ready() -> void:
	for i in n - 1:
		var b := Button.new()
		b.text = "(%d %d)" % [i + 1, i + 2]
		b.position = Vector2(size.x * (i + 1) / n - 25, size.y - 50)
		b.pressed.connect(func(): set_current(current.swap_positions(i, i + 1)))
		add_child(b)

func _column_x(i: int) -> float:
	return size.x * (i + 0.5) / n

func _draw() -> void:
	super._draw()
	for i in n:
		draw_text(Vector2(_column_x(i)-5, 30), str(i + 1))
		draw_text(Vector2(_column_x(i)-5, 100), str(current.row[i]))
	for i in n:
		_draw_curve(_column_x(i), _column_x(current.row.find(i + 1)))
		
		
func _draw_curve(x0: float, x1: float) -> void:
	var a := Vector2(x0, 38)
	var d := Vector2(x1, 80)
	var pts := PackedVector2Array()
	for k in 21:
		pts.append(a.bezier_interpolate(Vector2(x0, 59), Vector2(x1, 59), d, k / 20.0))
	draw_polyline(pts, Color.WHITE, 1.5, true)  # positive width is required for antialiasing

func same(a, b) -> bool: return a.equals(b)
func label(e) -> String: return e.cycle_label()

static func _perms(items: Array) -> Array:
	if items.size() <= 1: return [items]
	var out := []
	for i in items.size():
		var rest := items.duplicate(); rest.remove_at(i)
		for p in _perms(rest):
			out.append([items[i]] + p)
	return out

func elements() -> Array:
	var all := _perms(range(1, n + 1)).map(func(r): return Permutation.new(r))
	all.sort_custom(func(a, b): return _key(a) < _key(b))
	return all

func _key(p: Permutation) -> Array:
	var moved := 0
	for i in n: moved += int(p.row[i] != i + 1)
	return [moved, p.cycle_label().count("("), p.cycle_label()]
