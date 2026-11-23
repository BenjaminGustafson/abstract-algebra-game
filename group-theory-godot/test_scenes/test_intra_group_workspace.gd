extends Node2D

func _ready():
	var w := IntraGroupWorkspace.new(DihedralGroup.new(3))
	w.back_requested.connect(func(): print("back"))  # placeholder until main swaps workspaces
	add_child(w)
