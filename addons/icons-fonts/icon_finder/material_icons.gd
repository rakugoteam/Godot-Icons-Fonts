@tool
extends RichTextLabel

var size_slider: Slider

func update_table(filter := ""):
	var table = "[table={columns}, {inline_align}]"
	var columns := int(size.x / size_slider.value) + 1
	table = table.format({
		"columns": columns,
		"inline_align": INLINE_ALIGNMENT_CENTER
	})

	var cells := columns
	for key: String in IconsFonts.material_icons:
		if filter and filter.to_lower() not in key: continue
		cells -= 1
		if cells <= 0: cells = columns
		var link := "[url={link}]{text}[/url]"
		var text := IconsFonts.get_icon_char("MaterialIcons", key)
		link = link.format({"link": key, "text": text})

		var cell := "[cell]{link}[/cell]"
		table += cell.format({"link": link})
	
	if cells > 0:
		for c in cells:
			table += "[cell] [/cell]"

	table += "[/table]"
	parse_bbcode(table)
