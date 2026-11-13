extends Node2D

func _ready():
	var g := SymmetricGroup.new(4)
	g.position = Vector2(50, 50)
	add_child(g)
