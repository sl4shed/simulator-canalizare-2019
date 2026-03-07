@tool
extends Node2D

var bullet = preload("res://scenes/weapons/bullet.tscn")
@export var recoil = 40
@export var initialX = 70
@export var debounce = 0.2
@export var bullet_type: String = "shotgun"
@export var camera_shake: float = 0.4

var lerp_back_pos = false
var can_shoot = true

func _physics_process(delta: float) -> void:
	if lerp_back_pos:
		$sprite.position = $sprite.position.lerp(Vector2(initialX, $sprite.position.y), delta * 4)
		if $sprite.position.x == initialX: lerp_back_pos = false
	
func fire(player):
	if player.bullets[bullet_type] >= 4 and can_shoot:
		$sprite.position.x -= recoil
		lerp_back_pos = true
		$shoot.play()
		player.get_node("camera").trauma += camera_shake
		
		for child in $bullet_directions.get_children():
			var b = bullet.instantiate()
			player.bullets[bullet_type] -= 1
			b.global_position = child.global_position
			b.rotation = child.global_rotation
			get_tree().root.add_child(b)
		
		can_shoot = false
		await get_tree().create_timer(debounce).timeout
		$reload.play()
		await $reload.finished
		can_shoot = true
	elif can_shoot:
		$empty.play()
