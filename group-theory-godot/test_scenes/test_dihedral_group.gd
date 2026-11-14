extends Node2D

func _ready():
	for n in [3, 4, 5]:
		var g := DihedralGroup.new(n)
		g.position = Vector2(50 + 250 * (n - 3), 50)
		add_child(g)
		var l := ElementList.new(g, g.elements())
		l.position = g.position + Vector2(0, 220)
		add_child(l)
		#for e in g.elements():
			#g.set_current(e)
