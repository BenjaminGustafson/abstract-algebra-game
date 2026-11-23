class_name OptionTabs
extends VBoxContainer

signal option_chosen(option: String)

# One button per option name; the workspace decides what each option shows
func _init(names: Array) -> void:
	for n in names:
		var b := Button.new()
		b.text = n
		b.pressed.connect(option_chosen.emit.bind(n))
		add_child(b)
