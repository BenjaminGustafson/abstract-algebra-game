class_name ElementButtons
extends VBoxContainer

# One button per element, stacked below the group g and as wide as it
func _init(g: Group, elems: Array) -> void:
	position = Vector2(0, g.size.y)
	custom_minimum_size.x = g.size.x
	for e in elems:
		var b := Button.new()
		b.custom_minimum_size.x = g.size.x / 2  # half width, leaving the sides free for wires
		b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER  # centered in the list
		b.text = g.label(e)
		b.pressed.connect(func(): g.apply(e))
		add_child(b)
	var pad := Control.new()  # empty spacer so the last button clears the bottom border
	pad.custom_minimum_size.y = 8
	add_child(pad)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.1, 0.1, 0.1))  # same background as Group
	draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE, false)  # same border as Group
