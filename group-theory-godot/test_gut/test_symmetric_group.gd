extends GutTest

func test_same_and_label() -> void:
	var g = autofree(SymmetricGroup.new(3))
	assert_true(g.same(Permutation.new([2, 1, 3]), Permutation.new([2, 1, 3])))
	assert_eq(g.label(Permutation.new([2, 1, 3])), "(1 2)")

func test_elements() -> void:
	var g3 = autofree(SymmetricGroup.new(3))
	var labels = g3.elements().map(func(p): return p.cycle_label())
	assert_eq(labels, ["e", "(1 2)", "(1 3)", "(2 3)", "(1 2 3)", "(1 3 2)"])
	assert_eq(autofree(SymmetricGroup.new(4)).elements().size(), 24)
