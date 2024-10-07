@tool
@icon("res://addons/icons-fonts/nodes/FontIconButton.svg")
extends HBoxContainer

# todo add descreption and docs links when ready
class_name FontIconButton

@export var icon_settings: FontIconSettings:
	set(value):
		icon_settings = value
		if !is_node_ready(): await ready
		_font_icon.icon_settings = value

@export var text := "":
	set(value):
		text = value
		if !is_node_ready(): await ready
		_label.text = text

@export var label_settings: LabelSettings:
	set(value):
		label_settings = value
		if !is_node_ready(): await ready
		_label.label_settings = label_settings

@export_group("Styles", "style_")
@export var style_normal: StyleBox:
	set(value):
		style_normal = value
		add_theme_stylebox_override("normal", style_normal)

var _font_icon: FontIcon
var _label: Label

func _ready():
	_font_icon = FontIcon.new()
	add_child(_font_icon)
	_font_icon.add_theme_stylebox_override("normal", StyleBoxEmpty.new())

	_label = Label.new()
	add_child(_label)
	_label.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	
	# todo make HBox to look 
	style_normal = get_theme_stylebox("normal", "Button")
	
	# todo make HBox to behave like button
