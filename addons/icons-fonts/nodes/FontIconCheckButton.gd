@tool
@icon("res://addons/icons-fonts/nodes/FontIconButton.svg")
extends FontIconButton

# todo add description and docs links when ready
class_name FontIconCheckButton

@export var on_icon_settings := FontIconSettings.new():
	set(value):
		on_icon_settings = value
		if !is_node_ready(): await ready
		if button_pressed:
			_toggle_icon.icon_settings = value

@export var off_icon_settings := FontIconSettings.new():
	set(value):
		off_icon_settings = value
		if !is_node_ready(): await ready
		if !button_pressed:
			_toggle_icon.icon_settings = value

var _toggle_icon : FontIcon

func _ready():
	toggle_mode = true
	if get_child_count() != 0: return
	super._ready()
	var empty_style := StyleBoxEmpty.new()
	_toggle_icon = FontIcon.new()
	_toggle_icon.add_theme_stylebox_override("normal", empty_style)
	_box.add_child(_toggle_icon)

func _togglef(main_button: ButtonContainer, value: bool):
	if disabled: return
	if main_button == self: return
	if radio_mode and _toggled: return

	if value: _toggle_icon.icon_settings = icon_settings
	else: _toggle_icon.icon_settings = off_icon_settings
	super._togglef(main_button, value)
