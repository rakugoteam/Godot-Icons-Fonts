@tool
@icon("res://addons/icons-fonts/nodes/FontIconButton.svg")
extends FontIconButton

# todo add description and docs links when ready
class_name FontIconCheckButton

@export var off_icon_settings := FontIconSettings.new():
	set(value):
		off_icon_settings = value
		if !is_node_ready(): await ready

func _ready():
	toggle_mode = true
	super._ready()

func _togglef(main_button: ButtonContainer, value: bool):
	if disabled: return
	if main_button == self: return
	if radio_mode and _toggled: return

	if value: _font_icon.icon_settings = icon_settings
	else: _font_icon.icon_settings = off_icon_settings
	super._togglef(main_button, value)
