class_name MapMenu
extends GridContainer

signal room_chosen(coord: Vector2i)

var unlocked := {Vector2i(6, 2): "S3", Vector2i(6, 3): "D3"}

func _ready() -> void:
	columns = 20
	for row in range(1, 11):
		for col in range(1, 21):
			var c := Vector2i(col, row)
			var b := Button.new()
			b.custom_minimum_size = Vector2(40, 40)
			b.disabled = not unlocked.has(c)
			b.text = unlocked.get(c, "")
			b.pressed.connect(func(): room_chosen.emit(c))
			add_child(b)
