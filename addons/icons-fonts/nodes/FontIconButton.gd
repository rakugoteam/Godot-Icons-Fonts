@tool
@icon("res://addons/icons-fonts/nodes/FontIconButton.svg")

# todo add description and docs links when ready
class_name FontIconButton
extends ButtonContainer

@export_group("Icon", "icon_")
@export var icon_on_right := true:
	set(value):
		icon_on_right = value
		if !is_node_ready(): await ready
		if value: _box.move_child(_font_icon, 1)
		else: _box.move_child(_font_icon, 0)

@export var icon_settings := FontIconSettings.new():
	set(value):
		icon_settings = value
		if !is_node_ready(): await ready
		_font_icon.icon_settings = value

@export_group("Label", "label_")
@export var label_text := "":
	set(value):
		label_text = value
		if !is_node_ready(): await ready
		_label.text = label_text

@export var label_settings := LabelSettings.new():
	set(value):
		label_settings = value
		if !is_node_ready(): await ready
		_label.label_settings = label_settings

@export var button_margin := 5:
	set(value):
		button_margin = value
		if !is_node_ready(): await ready
		var margins := [
			"margin_top", "margin_left",
			"margin_bottom", "margin_right"
		]
		for margin in margins:
			_margins.add_theme_constant_override(margin, button_margin)

var _font_icon: FontIcon
var _label: Label
var _box: BoxContainer
var _margins: MarginContainer

func _ready():
	if get_child_count() != 0: return
	var empty_style := StyleBoxEmpty.new()
	_box = BoxContainer.new()
	_font_icon = FontIcon.new()
	_font_icon.add_theme_stylebox_override("normal", empty_style)
	_box.add_child(_font_icon)

	_label = Label.new()
	_label.add_theme_stylebox_override("normal", empty_style)
	_box.add_child(_label)

	self.icon_on_right = icon_on_right

	_margins = MarginContainer.new()
	_margins.add_child(_box)

	add_child(_margins)
