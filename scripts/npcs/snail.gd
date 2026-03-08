extends CharacterBody2D
@onready var player = GameManager.get_player()
@export var health = 200
const SPEED = 30
var bodies_in_zone = []
var can_infect = true

func _physics_process(delta: float) -> void:
	if player:
		var target = $sprite.global_position.direction_to(player.position).angle()
		$sprite.rotation = lerp_angle($sprite.rotation, target, delta * 0.5)
		
		velocity = Vector2.RIGHT.rotated($sprite.rotation) * SPEED
		move_and_slide()
		velocity = Vector2.RIGHT.rotated($sprite.rotation) * SPEED
		if velocity.length() > 0.1:
			$sprite.stop()
			$sprite.play("walk")
		else:
			$sprite.stop()
			$sprite.play("default")
		
		var angle = fmod($sprite.rotation_degrees, 360)
		if angle < 0: angle += 360
		$sprite.flip_v = angle > 90 and angle < 270
		
		if can_infect:
			for body in bodies_in_zone:
				if is_instance_valid(body) and body != self:
					if body.has_method("hurt"): body.hurt(5)
					if body.has_method("infect"): body.infect(10)
			if bodies_in_zone.size() > 0:
				can_infect = false
				await get_tree().create_timer(0.5).timeout
				can_infect = true

func hurt(damage):
	health -= damage
	if health <= 0:
		# todo particle sfx
		# and sound
		queue_free()

func _on_infection_zone_body_entered(body: Node2D) -> void:
	if not body in bodies_in_zone:
		bodies_in_zone.append(body)

func _on_infection_zone_body_exited(body: Node2D) -> void:
	bodies_in_zone.erase(body)
