extends Node2D

@export var item_scene: PackedScene
var sprite
var area: Area2D
var is_hovered = false

func _ready():
	var item = item_scene.instantiate()
	add_child(item)
	
	await get_tree().process_frame
	
	sprite = item.get_node("sprite")
	
	var mat = ShaderMaterial.new()
	mat.shader = load("res://misc/outline.gdshader")
	mat.set_shader_parameter("color", Color.RED)
	mat.set_shader_parameter("width", 10)
	sprite.material = mat
	
	var scaled_height = sprite.get_rect().size.y * abs(sprite.scale.y) * abs(item.scale.y)
	$text.global_position = Vector2(sprite.global_position.x - $text.size.x / 2, sprite.global_position.y + scaled_height / 2 + 5)

func _process(delta):
	if sprite == null:
		return
	var mouse = get_global_mouse_position()
	var dist = mouse.distance_to(sprite.global_position)
	var hovered = dist < 30  # adjust radius
	if hovered != is_hovered:
		is_hovered = hovered
		if hovered:
			sprite.material.set_shader_parameter("color", Color.WHITE)
			$text.visible = true
		else:
			sprite.material.set_shader_parameter("color", Color.RED)
			$text.visible = false
	
	if is_hovered and Input.is_action_pressed("use"):
		GameManager.get_player().get_node("ui/inventory").add_item(item_scene)
		GameManager.get_player().get_node("ui/inventory").shake()
		queue_free()
