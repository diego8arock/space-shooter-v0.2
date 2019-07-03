extends VBoxContainer
class_name SimpleDebug

onready var parent = get_parent()
export (bool) var run = false
var font: Font = preload("res://assets/fonts/12_kenny_high.tres")

func _process(delta: float) -> void:
	rect_rotation = 0

func add_label(_name: String) -> void:
	if has_node(_name):
		return
	var label = Label.new()
	label.name = _name
	label.add_font_override("font", font)
	add_child(label)

func update_label(_name: String, _value:String) -> void:
	if not run:
		return
	if has_node(_name):
		var label = get_node(_name)
		label.text = "[" + _name + "]: " + _value
	else:
		push_warning("No label [%s] exists for debug in [%s] " % [_name, parent.name])