@tool
extends Node2D

var bullet = preload("res://scenes/weapons/bullet.tscn")
@export var recoil = 40
@export var initialX = 70
@export var debounce = 0.2
@export var bullet_type: String = "shotgun"
@export var bullet_damage: int = 10
@export var bullet_speed: int = 2400
@export var durability: int = 200
@export var camera_shake: float = 0.4

@export var item_position: Vector2
@export var item_rotation: float
@export var item_scale: Vector2
var index = -1

var lerp_back_pos = false
var can_shoot = true

func update_bullet_count(player):
	$ui/panel/text.text = "[color=#ff3838]%s[/color] bullets left" % player.bullets[bullet_type]

func _physics_process(delta: float) -> void:
	if lerp_back_pos:
		position = position.lerp(Vector2(initialX, position.y), delta * 4)
		if position.x == initialX: lerp_back_pos = false
	
func fire(player):
	if player.bullets[bullet_type] >= $bullet_directions.get_child_count() and can_shoot:
		position.x -= recoil
		lerp_back_pos = true
		$shoot.play()
		player.get_node("camera").trauma += camera_shake
		player.get_node("ui/inventory").shake()
		durability -= 1
		
		for child in $bullet_directions.get_children():
			var b = bullet.instantiate()
			player.bullets[bullet_type] -= 1
			update_bullet_count(player)
			b.damage = bullet_damage
			b.speed = bullet_speed
			b.global_position = child.global_position
			b.rotation = child.global_rotation
			get_tree().root.add_child(b)
		
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
			$reload.play()
			await $reload.finished
			can_shoot = true
	elif can_shoot:
		$empty.play()
