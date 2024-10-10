@tool
# @singleton IconsFonts 
extends Node

const docked_setting_path := "application/addons/icon_finder/is_docked"
const prev_size_setting_path := "application/addons/icon_finder/preview_size"

## Material Icons
const material_icons_json := "res://addons/icons-fonts/icons_fonts/MaterialIcons/icons.json"
const material_icons_font := "res://addons/icons-fonts/icons_fonts/MaterialIcons/material_design_icons.ttf"
var material_icons := {}

static var is_docked: bool:
	set(value):
		ProjectSettings.set_setting(docked_setting_path, value)
	get:
		return ProjectSettings.get_setting(docked_setting_path, true)

static var preview_size: int:
	set(value):
		ProjectSettings.set_setting(prev_size_setting_path, value)
	get:
		return ProjectSettings.get_setting(prev_size_setting_path, 24)

func _ready():
	var content = get_file_content(material_icons_json)
	var json := JSON.new()

	if json.parse(content) == OK:
		init_icons_dictionaries(json.data)

func get_file_content(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	var content := ""
	
	if file.get_error() == OK:
		content = file.get_as_text()
		file.close()

	return content

func init_icons_dictionaries(data: Dictionary):
	material_icons = data
	for id in data:
		var hex = material_icons[id]
		material_icons[id] = ("0x" + hex).hex_to_int()
		# prints(id, material_icons[id])
	
	# prints("material_icons loaded")

func get_icon_code(font:String, id: String) -> int:
	if "," in id:
		id = id.split(",")[0]
	
	match font:
		"MaterialIcons":
			if id in material_icons:
				return material_icons[id]
		
		"Emojis": pass
		"GameIcons": pass
	
	push_warning("Icon '%s' in font %s not found." % [font, id])
	return 0

func get_icon_name(font:String, char: int) -> String:
	match font:
		"MaterialIcons":
			for icon in material_icons:
				if material_icons[icon] == char:
					return icon
		
		"Emojis": pass
		"GameIcons": pass

	push_warning("Icon with char '%s' in font %s not found." % [char, font])
	return ""

func get_icon_char(font: String, id: String) -> String:
	return char(get_icon_code(font, id))

## will parse text using:
##	-  parse_material_icons()
##	-  parse_emojis()
##	-  parse_game_icons()
func parse_text(text: String) -> String:
	text = parse_material_icons(text)
	# todo add emojis parse
	# todo add game-icons parse
	return text

## will replace [mi:icon_name] to [font=MaterialIcons]icon_char[/font]
func parse_material_icons(text: String) -> String:

	var regex = RegEx.new()
	regex.compile("\\[mi:(.*?)\\]")
	var x = regex.search(text)
	while x != null:
		var icon = x.get_string(1)
		var char = get_icon_char("MaterialIcons", icon)
		var r = "[font={font}]{char}[/font]"
		r = r.format({"font": material_icons_font, "char": char})

		if icon.split(",").size() > 1:
			var size = icon.split(",")[1]
			var s = "[font_size={size}]{r}[/font_size]"
			r = s.format({"size": size, "r": r})

		text = text.replace(x.get_string(), r)
		x = regex.search(text)
	
	return text
