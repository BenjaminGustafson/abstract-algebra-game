class_name IntraGroupWorkspace
extends Node2D

var group: Group
var list: ElementTable

const OPTIONS := ["Explorer", "Order", "Equivalence", "Generators"]
var options := OptionTabs.new(OPTIONS)
var panels := {}  # option name -> Node2D holding that option's content

func _ready() -> void:
	var view := get_viewport_rect().size
	group.position = Vector2(view.x * 0.125, view.y / 2) - group.size / 2  # centered in left quarter
	list.position = Vector2(view.x * 0.25, 0)
	list.size = Vector2(view.x * 0.75, view.y)  # right 3/4, full height
	options.position = Vector2(20, 20)  # top-left, above the panels


func _init(g: Group) -> void:
	group = g
	list = ElementTable.new(g, g.elements())
	add_child(list)
	add_child(options)
	for n in OPTIONS:
		panels[n] = Node2D.new()
		add_child(panels[n])
		var l := Label.new()  # placeholder content
		l.text = n
		l.position = Vector2(20, 200)
		panels[n].add_child(l)
	panels["Explorer"].add_child(group)  # the group lives in the Explorer panel
	options.option_chosen.connect(_show)
	_show("Explorer")
	
func _show(o: String) -> void:
	for n in panels:
		panels[n].visible = n == o  # hidden panels also stop receiving input
