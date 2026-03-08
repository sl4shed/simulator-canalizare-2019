extends TextureRect

@onready var initialHeight = size.y
var progress = 100

func set_progress(p):
	progress = p
	var height = progress * initialHeight / 100
	$progress.size.y = height
