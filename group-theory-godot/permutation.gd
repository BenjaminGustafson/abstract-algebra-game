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
	
func cycle_label() -> String:
	var seen := {}
	var s := ""
	for start in range(1, row.size() + 1):
		if seen.has(start) or row[start - 1] == start:
			continue
		var parts := PackedStringArray()
		var x := start
		while not seen.has(x):
			seen[x] = true
			parts.append(str(x))
			x = row[x - 1]
		s += "(" + " ".join(parts) + ")"
	return s if s != "" else "e"
	
