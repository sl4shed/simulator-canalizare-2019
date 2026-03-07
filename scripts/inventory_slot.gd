@tool
extends Panel

func _ready() -> void:
	$slot.rotation_degrees = randf_range(-10, 10)
	$slot.position += Vector2(randf_range(-5, 5), randf_range(-5, 5))

func shake() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
