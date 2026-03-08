extends Node2D

var is_hovered
@export var ammo_type = "pistol"
@export var ammo_amount = 12
@export var tint: Color

func _ready() -> void:
	$sprite.material.set_shader_parameter("tint", tint)

func _process(delta):
	var mouse = get_global_mouse_position()
	var dist = mouse.distance_to($sprite.global_position)
	var hovered = dist < 30
	if hovered != is_hovered:
		is_hovered = hovered
		if hovered:
			$sprite.material.set_shader_parameter("color", Color.WHITE)
			$text.visible = true
		else:
			$sprite.material.set_shader_parameter("color", Color.RED)
			$text.visible = false
	
	if is_hovered and Input.is_action_pressed("use"):
		GameManager.get_player().get_node("ui/inventory").shake()
		GameManager.get_player().bullets[ammo_type] += ammo_amount
		queue_free()
