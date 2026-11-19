extends Node2D

var rooms := {
	Vector2i(6, 2): Room.new(SymmetricGroup.new(3)),
	Vector2i(6, 3): Room.new(DihedralGroup.new(3)),
}
var map := MapMenu.new()
var current: Room

func _ready():
	add_child(map)
	map.position = (get_viewport_rect().size - map.get_combined_minimum_size()) / 2
	map.room_chosen.connect(_open)
	for r in rooms.values():
		r.back_requested.connect(_back)

func _open(c: Vector2i) -> void:
	remove_child(map)
	current = rooms[c]
	add_child(current)

func _back() -> void:
	remove_child(current)
	add_child(map)
