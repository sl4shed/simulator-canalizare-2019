extends CharacterBody2D
var player = null
@export var health = 40
@export var charge_speed = 600
@export var normal_speed = 0
var charging = false
var charge_direction = Vector2.ZERO

func _ready():
	player = GameManager.get_player()
	schedule_charge()

func schedule_charge():
	var wait = randf_range(3.0, 15.0)
	await get_tree().create_timer(wait).timeout
	if is_instance_valid(player):
		start_charge()
	else:
		player = GameManager.get_player()
		schedule_charge()

func start_charge():
	charging = true
	charge_direction = $sprite.global_position.direction_to(player.global_position)
	$sprite.play("walk")
	await get_tree().create_timer(0.6).timeout
	charging = false
	schedule_charge()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	var target = $sprite.global_position.direction_to(player.position).angle()
	$sprite.rotation = lerp_angle($sprite.rotation, target, delta * 0.5)
	
	if charging:
		velocity = charge_direction * charge_speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	if velocity.length() > 0.1:
		$sprite.play("walk")
	else:
		$sprite.stop()
		$sprite.play("default")
	
	var angle = fmod($sprite.rotation_degrees, 360)
	if angle < 0: angle += 360
	$sprite.flip_v = angle > 90 and angle < 270

func hurt(damage):
	health -= damage
	if health <= 0:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self: return
	if body.has_method("hurt"):
		body.hurt(45)
