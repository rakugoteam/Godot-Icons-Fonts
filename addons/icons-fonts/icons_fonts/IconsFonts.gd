@tool
# @singleton IconsFonts
extends Node

const docked_setting_path := "application/addons/icon_finder/is_docked"
const prev_size_setting_path := "application/addons/icon_finder/preview_size"
const material_icons_dir := "res://addons/icons-fonts/icons_fonts/MaterialIcons/"
const json_path := material_icons_dir + "icons.json"
const font_path := material_icons_dir + "material_design_icons.ttf"

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

@onready var font := preload(font_path) as FontFile
var icons := {}

func _ready():
	var content = get_file_content(json_path)
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
	icons = data
	for id in data:
		var hex = icons[id]
		icons[id] = ("0x" + hex).hex_to_int()
		# prints(id, icons[id])
	
	# prints("icons loaded")

func get_icon_code(id: String) -> int:
	if "," in id:
		id = id.split(",")[0]
	
	if id in icons:
		return icons[id]
	
	push_warning("Icon '%s' not found." % id)
	return 0

func get_icon_name(char: int) -> String:
	for icon in icons:
		if icons[icon] == char:
			return icon

	push_warning("Icon with char '%s' not found." % char)
	return ""

func get_icon_char(id: String) -> String:
	return char(get_icon_code(id))

func parse_icons(text: String) -> String:
	# take replace [icon] to [font=MaterialIcons]icon_char[/font]
	var regex = RegEx.new()
	regex.compile("\\[icon:(.*?)\\]")
	var x = regex.search(text)
	while x != null:
		var icon = x.get_string(1)
		var char = get_icon_char(icon)
		var r = "[font={font}]{char}[/font]"
		r = r.format({"font": font_path, "char": char})

		if icon.split(",").size() > 1:
			var size = icon.split(",")[1]
			var s = "[font_size={size}]{r}[/font_size]"
			r = s.format({"size": size, "r": r})

		text = text.replace(x.get_string(), r)
		x = regex.search(text)
	
	return text
