@tool
extends Window

func _ready() -> void:
	close_requested.connect(hide)

func setup():
	$IconFinder.setup()