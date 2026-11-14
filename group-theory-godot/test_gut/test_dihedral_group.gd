extends GutTest

func test_elements() -> void:
	var g = autofree(DihedralGroup.new(3))
	var labels = g.elements().map(func(p): return p.cycle_label())
	labels.sort()
	assert_eq(labels, ["(1 2 3)", "(1 2)", "(1 3 2)", "(1 3)", "(2 3)", "e"])
	assert_eq(autofree(DihedralGroup.new(4)).elements().size(), 8)

func test_pose() -> void:
	var g = autofree(DihedralGroup.new(3))
	var cases := [[[1,2,3], 0.0, 1.0], [[2,3,1], 2*TAU/3, 1.0], [[3,2,1], 2*TAU/3, -1.0], [[1,3,2], 0.0, -1.0]]
	for c in cases:
		var p = g.pose_of(Permutation.new(c[0]))
		assert_almost_eq(p[0], c[1], 0.001, str(c[0]))
		assert_eq(p[1], c[2], str(c[0]))
