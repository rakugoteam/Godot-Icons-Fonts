@tool
@icon("res://addons/icons-fontsnodes/FontIconButton.svg")
extends Button

# todo add descreption and docs links when ready
class_name FontIconButton

@export_group("Icon", "icon_")
## Name of Icon to display
@export var icon_name := "image-outline":
	set(value):
		icon_name = value
		text = IconsFonts.get_icon_char(value)
	
	get: return icon_name

@export_group("Icon", "icon_")
## Size of the icon in range 16-128
@export_range(16, 128, 1)
var icon_size := 16:
	set(value):
		icon_size = value
		set("theme_override_font_sizes/font_size",value)
	
	get: return icon_size

func _ready():
	clip_text = false
	var font := IconsFonts
	text = IconsFonts.get_icon_char(icon_name)
	set("theme_override_fonts/font",font)
	set("theme_override_font_sizes/font_size",icon_size)
