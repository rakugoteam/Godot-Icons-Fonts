@tool
class_name IconsFontsRender
extends RichTextLabel

@export_enum("MaterialIcons", "Emojis", "GameIcons")
var icon_font := "MaterialIcons"
@export_range(0.1, 1.0, 0.1) var render_time := 0.1
@export var size_slider: Slider

func set_icons_size(value:int):
	set("theme_override_font_sizes/normal_font_size", value)

func get_font_data() -> Dictionary:
	var data := {}
	match icon_font:
		"MaterialIcons": data =  IconsFonts.material_icons
		"Emojis": data = IconsFonts.emojis
		_: text = "Unsupported IconsFont %s" % icon_font
	
	return data

func get_icon(key:String) -> String:
	match icon_font:
		"MaterialIcons": return IconsFonts.get_icon_char("MaterialIcons", key)
		"Emojis": return str(IconsFonts.emojis[key])
	
	return ""

func setup():
	set_meta_underline(false)
	await get_tree().create_timer(render_time).timeout
	update_table()

func update_table(filter := ""):
	var table = "[table={columns}, {inline_align}]"
	var columns := int(size.x / size_slider.value) + 1
	table = table.format({
		"columns": columns,
		"inline_align": INLINE_ALIGNMENT_CENTER
	})

	var data := get_font_data()
	if !data: return

	var cells := columns
	for key: String in data:
		if filter and filter.to_lower() not in key: continue
		cells -= 1
		if cells <= 0: cells = columns
		var link := "[url={link}]{icon}[/url]"
		var icon := get_icon(key)
		link = link.format({"link": key, "icon": icon})

		var cell := "[cell]{link}[/cell]"
		table += cell.format({"link": link})
	
	cells = abs(cells)
	while cells > columns:
		cells -= 1
	
	if cells > 0:
		for c in cells:
			table += "[cell] [/cell]"

	table += "[/table]"
	parse_bbcode(table)
