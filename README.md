![github-top-lang][lang] ![lic] ![lic-font]

# Godot Icons Fonts

**Compatible with Godot 4.1+**

Makes easy to find and use icons from popular icon-fonts in your Godot project.

## What problems it solves:

- You only needs this addon - as you don't have:
	1. to go online find font
	1. then find icon
	1. check icon licence - and maybe you need to search for another
	1. finally download it

- Better alterative to Godot's build emojis as:
	- to use them you need to find unicode online
	- they don't work on some platforms for example Web
	- they are outdated

## Included

### Dependencies
- [Rakugo Nodes](https://github.com/Jeremi360/Rakugo-Nodes)

### Icons Fonts
- [*Templarian's Material-Design-Icons*](https://github.com/templarian/MaterialDesign),
	a collection of icons for the [Material Design](https://material.io/) specification.

- [Google Noto Emojis Color font][noto-emoji]
<!-- feature versions: -->
<!-- - [game-icons.net](https://github.com/toddfast/game-icons-net-font) -->
<!-- - godot-icons -->

<!-- todo update to show new nodes and one example of each icons font included-->
![](.assets/addon-in-action.png)

<!-- todo add link to docs when they are ready -->
<!-- todo add screenshots, and how to use them -->

### Resource
**FontIconSetting** - Resource for setting which and how to display FontIcon.

### Nodes
- **FontIcon**: Control Node that displays IconFont.
- **FontIconButton**: Button* That have IconFont and can have label.
- **FontIconCheckButton**: CheckButton* That have IconFont and can have label.

\* - This nodes behaves like button,
but they don't extends from **Button**.

### Singleton
**IconsFonts** is singleton for easier use of icons anywhere in your project.

## In Editor

<!-- todo add paragraph about dock mode by default -->
It's also adds **IconsFinder**.
It can be in dock mode at bottom or in window mode.
That can be switched in Godot's **Tools** menu.

<!-- todo update -->
![](.assets/where-in-menu.png)

So you can find the icons easily.

<!-- todo update -->
![IconsFinder Screen Shot](.assets/icon-finder.png)

## Using it with RichTextLabel
You can use the icons in RichTextLabel.

![](.assets/label-with-icon.png)

```gdscript
@tool
extends RichTextLabel

@export_multiline
var text_with_icons : String:
	set(value):
		text_with_icons = value
		bbcode_enabled = true
		text = IconsFonts.parse_icons(value)

	get: return text_with_icons

func _ready():
	bbcode_enabled = true
	text = IconsFonts.parse_icons(text_with_icons)
```

## Exporting
For emojis to work in exported projects,
you need add `*.json` files to include files settings:
![include files settings](.assets/export.png)

[lic]: https://img.shields.io/github/license/rakugoteam/Godot-Material-Icons?style=flat-square&label=📃%20License&
[lang]: https://img.shields.io/github/languages/top/rakugoteam/Godot-Material-Icons?style=flat-square
[lic-font]:https://img.shields.io/static/v1.svg?label=📜%20Font%20License&message=Pictogrammers%20Free%20License&color=informational&style=flat-square
[noto-emoji]:https://github.com/googlefonts/noto-emoji/tree/main/png
