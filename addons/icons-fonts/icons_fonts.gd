@tool
# @singleton IconsFonts
extends EditorPlugin

const plugin_dir := "res://addons/icons-fonts/"
const icons_db := plugin_dir + "icons_fonts/IconsFonts.gd"
const icon_finder_dir := plugin_dir + "icon_finder/"
const icon_finder_window_scene := icon_finder_dir + "IconFinderWindow.tscn"
const icon_finder_scene := icon_finder_dir + "IconFinder.tscn"

var command_palette := get_editor_interface().get_command_palette()
var editor_interface := get_editor_interface().get_base_control()
var icon_finder_window: Window
var icon_finder: Control
var popup_size := Vector2i(775, 400)

var commands := [
	["Icon Finder Window", "icon_finder_window", show_icon_finder],
	["Icon Finder Dock", "icon_finder_dock", add_to_dock],
	# todo uncomment when docs are ready!
	# ["IconsFonts Help", "icon_help", help],
]

func _enter_tree():
	add_autoload_singleton("IconsFonts", icons_db)

	await IconsFonts.ready

	if IconsFonts.is_docked: add_to_dock()

	for command: Array in commands:
		add_tool_menu_item(command[0], command[2])
		command_palette.add_command(command[0], command[1], command[2])

func help():
	# todo update when docs are ready!
	# OS.shell_open("https://rakugoteam.github.io/material-icons-docs/")
	pass

func add_to_dock():
	icon_finder = load(icon_finder_scene).instantiate()
	add_control_to_bottom_panel(icon_finder, "Icons Finder")
	await icon_finder.ready
	icon_finder.custom_minimum_size = popup_size
	icon_finder.setup()

func show_icon_finder():
	remove_control_from_bottom_panel(icon_finder)
	icon_finder.queue_free()
	IconsFonts.is_docked = false

	if icon_finder_window == null:
		icon_finder_window = load(icon_finder_window_scene).instantiate()
		editor_interface.add_child.call_deferred(icon_finder_window)
		await icon_finder.ready
		icon_finder.custom_minimum_size = popup_size
		icon_finder_window.setup()
	
	icon_finder_window.theme = editor_interface.theme
	icon_finder_window.popup_centered(popup_size)

func _exit_tree():
	for command: Array in commands:
		remove_tool_menu_item(command[0])
		command_palette.remove_command(command[0])
	
	remove_autoload_singleton("IconsFonts")

	if icon_finder:
		remove_control_from_bottom_panel(icon_finder)
		icon_finder.queue_free()

	if icon_finder_window:
		icon_finder_window.queue_free()
