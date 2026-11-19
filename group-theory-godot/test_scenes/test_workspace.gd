extends Node2D

func _ready():
	var w := Workspace.new()
	w.position = Vector2(50, 50)
	add_child(w)
	
	var g := SymmetricGroup.new(3)
	g.position = Vector2(200, 200)
	w.content.add_child(g)  # children of content zoom and pan with the grid
