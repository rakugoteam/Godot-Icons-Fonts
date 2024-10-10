@tool
@icon("res://addons/custom-ui-elements/nodes/ButtonContainer.svg")
extends PanelContainer

# todo add descreption and docs links when ready
class_name ButtonContainer

## Emitted when button is pressed
signal pressed
## Emitted when button is toggled
## Works only if `toggle_mode` is on.
signal toggled(value: bool)

## If true, button will be disabled
@export var disabled := false:
	set(value):
		disabled = value
		if disabled:
			_change_stylebox("disabled")
			return
		
		_change_stylebox("normal")

## If true, button will be in toggle mode
@export var toggle_mode := false
var _toggled := false:
	get: return _toggled

## If true, on one button in group will be toggled
## needs toggle_mode = true to works
@export var radio_mode := false

## If true, button will be in pressed state
@export var button_pressed := false:
	set(value):
		if toggle_mode:
			_togglef(null, value)
			button_pressed = value
			return
		
		emit_signal("pressed")

## Name of node group to be used as button group
## It changes all toggleable buttons in group in to radio buttons
@export var button_group: StringName = ""

@export_group("Styles", "style_")
@export var style_normal: StyleBox:
	set(value):
		style_normal = value
		if !disabled or !button_pressed:
			_change_stylebox("normal")

@export_group("Styles", "style_")
@export var style_focus: StyleBox

@export_group("Styles", "style_")
@export var style_pressed: StyleBox:
	set(value):
		style_pressed = value
		if !disabled and button_pressed:
			_change_stylebox("pressed")

@export_group("Styles", "style_")
@export var style_hover: StyleBox

@export_group("Styles", "style_")
@export var style_disabled: StyleBox:
	set(value):
		style_disabled = value
		if disabled:
			_change_stylebox("disabled")

func connect_if_possible(sig: Signal, method: Callable):
	if !sig.is_connected(method): sig.connect(method)

func _ready() -> void:
	_change_stylebox("normal")
	
	connect_if_possible(mouse_entered, func(): _change_stylebox("hover"))
	connect_if_possible(mouse_exited, _on_mouse_exited)
	
	if button_group: add_to_group(button_group)

func _on_mouse_exited():
	if toggle_mode and _toggled:
		_change_stylebox("pressed")
		return

	_change_stylebox("normal")

func _change_stylebox(button_style: StringName = "normal"):
	
	prints("changed style to:", button_style)
	var stylebox := get_theme_stylebox(button_style, "Button")
	if button_style == "normal" and style_normal:
		stylebox = style_normal
	
	elif button_style == "focus" and style_focus:
		stylebox = style_focus
	
	elif button_style == "pressed" and style_pressed:
		stylebox = style_pressed
	
	elif button_style == "hover" and style_hover:
		stylebox = style_hover
	
	elif button_style == "disabled" and style_disabled:
		stylebox = style_disabled

	add_theme_stylebox_override("panel", stylebox)

func _gui_input(event: InputEvent) -> void:
	if disabled: return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if toggle_mode:
				var t := !_toggled
				_togglef(null, t)
				
				if button_group:
					get_tree().call_group(button_group, "_togglef", self, !t)
					return
			
			pressed.emit()
			# print("pressed")

func _togglef(main_button: ButtonContainer, value: bool):
	if disabled: return
	if main_button == self: return
	if radio_mode and _toggled: return

	_toggled = value
	if value: _change_stylebox("pressed")
	else: _change_stylebox("normal")

	toggled.emit(_toggled)
