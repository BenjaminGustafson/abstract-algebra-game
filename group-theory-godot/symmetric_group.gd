class_name SymmetricGroup
extends Group

var n: int

func _init(degree: int) -> void:
	n = degree
	size = Vector2(60 * n, 180)
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
		draw_string(ThemeDB.fallback_font, Vector2(_column_x(i), 30), str(i + 1))
		draw_string(ThemeDB.fallback_font, Vector2(_column_x(i), 100), str(current.row[i]))
	for i in n:
		_draw_curve(_column_x(i), _column_x(current.row.find(i + 1)))
		
		
func _draw_curve(x0: float, x1: float) -> void:
	var a := Vector2(x0, 38)
	var d := Vector2(x1, 80)
	var pts := PackedVector2Array()
	for k in 21:
		pts.append(a.bezier_interpolate(Vector2(x0, 59), Vector2(x1, 59), d, k / 20.0))
	draw_polyline(pts, Color.WHITE)
