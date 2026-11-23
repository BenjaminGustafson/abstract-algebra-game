extends Node2D

var workspace := Workspace.new()

func _ready() -> void:
	add_child(workspace)
	var groups := [SymmetricGroup.new(3), DihedralGroup.new(3)]
	for i in groups.size():
		workspace.add_group(groups[i], Vector2(200 + 400 * i, 200))  # S3 left, D3 right
	workspace.group_opened.connect(_open)
	
# Swaps the inter-group workspace for the group's interior
func _open(g: Group) -> void:
	var pos := g.position  # restored on return; the interior repositions the group
	g.get_parent().remove_child(g)  # must be parentless before the interior adopts it
	g.enter_interior()
	var interior := IntraGroupWorkspace.new(g)
	interior.back_requested.connect(_close.bind(interior, g, pos))
	remove_child(workspace)  # stays alive, just out of the tree
	add_child(interior)

# Reverses _open: returns the group to the grid and drops the interior
func _close(interior: IntraGroupWorkspace, g: Group, pos: Vector2) -> void:
	g.get_parent().remove_child(g)
	g.exit_interior()
	g.position = pos
	workspace.content.add_child(g)
	remove_child(interior)
	interior.queue_free()
	add_child(workspace)
