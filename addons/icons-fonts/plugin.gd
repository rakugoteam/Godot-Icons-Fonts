@tool
extends EditorPlugin

const icons_db := "res://addons/material-design-icons/icons/icons.gd"
const icon_finder_window_scene := \
	"res://addons/material-design-icons/icon_finder/IconFinderWindow.tscn"
const icon_finder_scene := \
	"res://addons/material-design-icons/icon_finder/IconFinder.tscn"
var command_palette := get_editor_interface().get_command_palette()
var editor_interface := get_editor_interface().get_base_control()
var icon_finder_window: Window
var icon_finder: Panel
var popup_size := Vector2i(775, 400)

func _enter_tree():
	add_autoload_singleton("IconsFonts", icons_db)
	await IconsFonts.ready

	if IconsFonts.is_docked: add_to_dock()

	add_tool_menu_item("Material Icon Finder Window", show_icon_finder)
	add_tool_menu_item("Material Icon Finder Dock", add_to_dock)
	add_tool_menu_item("Material Icon Help", help)

	command_palette.add_command(
		"Material Icon Finder Window", "icon_finder_window", show_icon_finder)
	command_palette.add_command(
		"Material Icon Finder Dock", "icon_finder_dock", add_to_dock)
	command_palette.add_command("Material Icon Help", "icon_help", help)

func help():
	OS.shell_open("https://rakugoteam.github.io/material-icons-docs/")

func add_to_dock():
	icon_finder = load(icon_finder_scene).instantiate()
	add_control_to_bottom_panel(icon_finder, "Material Icons")
	icon_finder.update_table()

func show_icon_finder():
	remove_control_from_bottom_panel(icon_finder)
	icon_finder.queue_free()
	IconsFonts.is_docked = false

	if icon_finder_window == null:
		icon_finder_window = load(icon_finder_window_scene).instantiate()
		editor_interface.add_child.call_deferred(icon_finder_window)
	
	icon_finder_window.theme = editor_interface.theme
	icon_finder_window.popup_centered(popup_size)

func _exit_tree():
	remove_tool_menu_item("Find Material Icon")
	command_palette.remove_command("find_icon")
	remove_autoload_singleton("IconsFonts")

	if icon_finder:
		remove_control_from_bottom_panel(icon_finder)
		icon_finder.queue_free()

	if icon_finder_window:
		icon_finder_window.queue_free()