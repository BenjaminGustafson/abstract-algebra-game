class_name ElementTable
extends ScrollContainer

# One row per element; later columns are extra children of each row
func _init(g: Group, elems: Array) -> void:
	var box := VBoxContainer.new()
	add_child(box)
	for e in elems:
		var row := HBoxContainer.new()
		var b := Button.new()
		b.text = g.label(e)
		b.pressed.connect(func(): g.apply(e))
		row.add_child(b)
		box.add_child(row)
