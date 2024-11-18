@tool
@icon("res://addons/icons-fonts/nodes/FontIconButton.svg")
extends FontIconButton

# todo add description and docs links when ready
class_name FontIconCheckButton

@export var toggle_on_right := true:
	set(value):
		toggle_on_right = value
		if !is_node_ready(): await ready
		if value: _box.move_child(_toggle_icon, 2)
		else: _box.move_child(_toggle_icon, 0)

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
	for ch in get_children():
		ch.queue_free()

	super._ready()
	var empty_style := StyleBoxEmpty.new()
	_toggle_icon = FontIcon.new()
	_toggle_icon.add_theme_stylebox_override("normal", empty_style)
	_box.add_child(_toggle_icon)

	self.toggle_on_right = toggle_on_right

func _togglef(main_button: ButtonContainer, value: bool):
	if disabled: return
	if main_button == self: return
	if radio_mode and _toggled: return

	if value: _toggle_icon.icon_settings = on_icon_settings
	else: _toggle_icon.icon_settings = off_icon_settings
	super._togglef(main_button, value)
