extends Node2D

var valid = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not valid: false
	if not body.has_method("infect"): return
	for collectible in get_children():
		valid = false
		collectible.initialize()
	print("asjkpsfdjlksfdjksfdakds")
