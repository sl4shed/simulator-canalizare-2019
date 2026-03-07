@tool
extends Panel

var shaking = false
var shake_time = 0.0
var shake_duration = 0.4
var shake_speed = 20.0
var shake_amount = 25.0
var start_rotation = 0.0
var end_rotation = 0.0

func _ready() -> void:
	$slot.rotation_degrees = randf_range(-10, 10)
	$slot.position += Vector2(randf_range(-5, 5), randf_range(-5, 5))

func shake() -> void:
	shaking = true
	shake_time = 0.0
	start_rotation = $slot.rotation_degrees
	end_rotation = randf_range(-10, 10)

func _process(delta: float) -> void:
	if shaking:
		shake_time += delta
		var progress = shake_time / shake_duration
		var dampen = 1.0 - progress
		var hinge = sin(shake_time * shake_speed) * shake_amount * dampen
		$slot.rotation_degrees = lerp(start_rotation, end_rotation, progress) + hinge
		if shake_time >= shake_duration:
			$slot.rotation_degrees = end_rotation
			shaking = false

func set_item(item_scene: PackedScene) -> void:
	for child in $slot/viewport/subviewport.get_children():
		child.queue_free()
	
	if item_scene == null:
		return
		
	var item = item_scene.instantiate()
	$slot/viewport/subviewport.add_child(item)
	
	await get_tree().process_frame
	item.position = item.item_position
	item.rotation_degrees = item.item_rotation
	item.scale = item.item_scale

func get_item() -> Node2D:
	return $slot/viewport/subviewport.get_child(0)

func set_node_item(item_scene: Node2D) -> void:
	for child in $slot/viewport/subviewport.get_children():
		child.queue_free()
	
	if item_scene == null:
		return
		
	var item = item_scene.duplicate()
	$slot/viewport/subviewport.add_child(item)
	
	await get_tree().process_frame
	item.position = item.item_position
	item.rotation_degrees = item.item_rotation
	item.scale = item.item_scale
