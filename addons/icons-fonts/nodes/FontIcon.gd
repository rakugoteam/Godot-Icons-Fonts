@tool
@icon("res://addons/icons-fonts/nodes/FontIcon.svg")
extends Label

# todo add descreption and docs links when ready
## Don't change LabelSettings value in this node!
class_name FontIcon

@export var icon_settings := FontIconSettings.new():
	set(value):
		icon_settings = value
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