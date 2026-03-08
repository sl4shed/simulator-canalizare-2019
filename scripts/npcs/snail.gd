extends CharacterBody2D

@onready var player = GameManager.get_player()
const SPEED = 30

func _physics_process(delta: float) -> void:
	var target = $sprite.global_position.direction_to(player.position).angle()
	$sprite.rotation = lerp_angle($sprite.rotation, target, delta * 0.5)
	
	velocity = Vector2.RIGHT.rotated($sprite.rotation) * SPEED
	move_and_slide()
	velocity = Vector2.RIGHT.rotated($sprite.rotation) * SPEED
	
	var angle = fmod($sprite.rotation_degrees, 360)
	if angle < 0: angle += 360
	$sprite.flip_v = angle > 90 and angle < 270
