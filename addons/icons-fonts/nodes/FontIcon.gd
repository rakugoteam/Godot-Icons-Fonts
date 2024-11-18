@tool
@icon("res://addons/icons-fonts/nodes/FontIcon.svg")

# todo add description and docs links when ready
## Don't change LabelSettings value in this node!
class_name FontIcon
extends Label

@export var icon_settings := FontIconSettings.new():
	set(value):
		icon_settings = value
		if !is_node_ready(): await ready
		if !icon_settings.changed.is_connected(_on_icon_settings_changed):
			icon_settings.changed.connect(_on_icon_settings_changed)
		icon_settings.emit_changed()

func _ready():
	clip_text = false
	_on_icon_settings_changed()

func _on_icon_settings_changed():
	if !label_settings:
		label_settings = LabelSettings.new()
		label_settings.changed.connect(_on_icon_settings_changed)
	
	icon_settings.update_label_settings(label_settings)
	text = IconsFonts.get_icon_char(
		icon_settings.icon_font,
		icon_settings.icon_name
	)