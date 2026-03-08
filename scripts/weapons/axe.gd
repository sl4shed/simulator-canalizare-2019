@tool
extends Node2D

@export var debounce = 0.2
@export var damage: int = 7
@export var durability: int = 200
@export var camera_shake: float = 0.05
@export var initialX = 0
var can_shoot = true

@export var item_position: Vector2
@export var item_rotation: float
@export var item_scale: Vector2
var index = -1

func fire(player):
	$AnimationPlayer.play("fire")
	player.get_node("camera").trauma += camera_shake
	player.get_node("ui/inventory").shake()
	durability -= 1
	
	if durability == 0:
		var break_sound = $break
		remove_child(break_sound)
		get_tree().root.add_child(break_sound)
		break_sound.play()
		player.get_node("camera").trauma += 0.6
		player.get_node("ui/inventory").remove_index(index)
		queue_free()
	else:
		can_shoot = false
		await get_tree().create_timer(debounce).timeout
		can_shoot = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt(damage)
