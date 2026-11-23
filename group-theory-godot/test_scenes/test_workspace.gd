extends Node2D

func _ready():
	var w := Workspace.new()
	w.position = Vector2(50, 50)
	add_child(w)
	
	var groups := [SymmetricGroup.new(3), DihedralGroup.new(3)]
	for i in groups.size():
		w.add_group(groups[i], Vector2(200 + 400 * i, 200))  # S3 left, D3 right
	w.group_opened.connect(func(g): print(g))  # placeholder until the intra workspace is wired
