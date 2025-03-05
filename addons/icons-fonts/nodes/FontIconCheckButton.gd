@tool
@icon("res://addons/icons-fonts/nodes/FontIconButton.svg")

# todo add description and docs links when ready
class_name FontIconCheckButton
extends FontIconButton

@export var on_icon_settings := FontIconSettings.new():
	set(value):
		on_icon_settings = value
		if !is_node_ready(): await ready
		_toggle_icon_on.icon_settings = value

@export var off_icon_settings := FontIconSettings.new():
	set(value):
		off_icon_settings = value
		if !is_node_ready(): await ready
		_toggle_icon_off.icon_settings = value

var _toggle_icon_on: FontIcon
var _toggle_icon_off: FontIcon
var _toggle_icon_box: BoxContainer

func _ready():
	toggle_mode = true
	if "Toggle" not in layout_order:
		layout_order = "Label-Icon-Toggle"

	super._ready()
	_toggle_icon_box = BoxContainer.new()
	
	_toggle_icon_on = _add_icon(on_icon_settings)
	_toggle_icon_on.visible = button_pressed
	_toggle_icon_box.add_child(_toggle_icon_on)

	_toggle_icon_off = _add_icon(off_icon_settings)
	_toggle_icon_off.visible = !button_pressed
	_toggle_icon_box.add_child(_toggle_icon_off)

func _on_on_icon_changed():
	update_icon(on_icon_settings, _toggle_icon_on)

func _on_off_icon_changed():
	update_icon(off_icon_settings, _toggle_icon_on)

func _togglef(main_button: ButtonContainer, value: bool):
	if disabled: return
	if main_button == self: return
	_toggle_icon_on.visible = value
	_toggle_icon_off.visible = !value
	super._togglef(main_button, value)

func _get_lay_dict() -> Dictionary:
	return {
		"Label": _label,
		"Icon": _font_icon,
		"Toggle": _toggle_icon_box
	}

func _validate_property(property : Dictionary) -> void:
	if property.name == &"layout_order":
		property.hint_string = ",".join([
			"Label-Icon-Toggle", "Label-Toggle-Icon",
			"Toggle-Label-Icon", "Toggle-Icon-Label",
			"Icon-Label-Toggle", "Icon-Toggle-Label",
			"Label-Toggle", "Toggle-Label", "Toggle"
		])
