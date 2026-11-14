extends GutTest

func test_cycle_label() -> void:
	var cases := [
		[[1, 2, 3], "e"],
		[[2, 1, 3], "(1 2)"],
		[[3, 2, 1], "(1 3)"],
		[[1, 3, 2], "(2 3)"],
		[[2, 3, 1], "(1 2 3)"],
		[[3, 1, 2], "(1 3 2)"],
		[[2, 1, 4, 3], "(1 2)(3 4)"],
	]
	for c in cases:
		assert_eq(Permutation.new(c[0]).cycle_label(), c[1], str(c[0]))
