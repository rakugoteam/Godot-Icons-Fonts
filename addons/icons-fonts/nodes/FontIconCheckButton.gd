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

func _init() -> void:
	layout_order = "Label-Icon-Toggle"

func _add_toggle_icon(icon_settings: FontIconSettings, on_changed: Callable ) -> FontIcon:
	var empty_style := StyleBoxEmpty.new()
	var toggle_icon = FontIcon.new()
	toggle_icon.add_theme_stylebox_override("normal", empty_style)
	_toggle_icon_box.add_child(toggle_icon)
	Utils.connect_if_possible(icon_settings, "changed", on_changed)
	return toggle_icon

func _ready():
	toggle_mode = true
	super._ready()
	_toggle_icon_box = BoxContainer.new()
	_toggle_icon_on = _add_toggle_icon(on_icon_settings, _on_on_icon_changed)
	_toggle_icon_off = _add_toggle_icon(off_icon_settings, _on_off_icon_changed)
	_toggle_icon_on.visible = button_pressed
	_toggle_icon_off.visible = !button_pressed
	self.layout_order = layout_order

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
