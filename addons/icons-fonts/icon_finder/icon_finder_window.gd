@tool
extends Window

func _ready() -> void:
	close_requested.connect(hide)

func setup():
	if !is_node_ready(): await ready
	$IconFinder.setup()