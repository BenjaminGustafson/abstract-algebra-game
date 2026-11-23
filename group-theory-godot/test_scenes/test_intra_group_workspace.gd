extends Node2D

func _ready():
	add_child(IntraGroupWorkspace.new(DihedralGroup.new(3)))
