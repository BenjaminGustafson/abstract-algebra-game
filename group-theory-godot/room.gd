class_name Room
extends Node2D

signal back_requested

var group: Group

func _init(g) -> void:
	group = g 
	add_child(g)
	var l := ElementList.new(g, g.elements())
	l.position = Vector2(300, 50)
	add_child(l)
	var b := Button.new()
	b.text = "back"
	b.position = Vector2(10, 10)
	b.pressed.connect(back_requested.emit)
	add_child(b)

func _ready() -> void:
	group.position = (get_viewport_rect().size - group.size) / 2
