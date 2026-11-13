class_name Permutation
extends RefCounted

var row: Array  # bottom row, e.g. [2, 1, 3]

func _init(r: Array) -> void:
	row = r.duplicate()

func swap_positions(i: int, j: int) -> Permutation:
	var r := row.duplicate()
	r[i] = row[j]
	r[j] = row[i]
	return Permutation.new(r)

func equals(other: Permutation) -> bool:
	return row == other.row
	
