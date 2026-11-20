extends Node2D

func _ready():
	var w := Workspace.new()
	w.position = Vector2(50, 50)
	add_child(w)
	
	var groups := [SymmetricGroup.new(3), DihedralGroup.new(3)]
	for i in groups.size():
		var g: Group = groups[i]
		g.position = Vector2(200 + 400 * i, 200)  # S3 left, D3 right
		w.content.add_child(g)
		g.add_child(ElementButtons.new(g, g.elements()))  # list rides along with the group
