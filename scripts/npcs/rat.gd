extends CharacterBody2D
var player = null
@export var health = 100
@export var speed = 300
var move_direction = Vector2.ZERO
var move_timer = 0.0
var idle_timer = 0.0
var is_moving = false

func _ready():
	player = GameManager.get_player()
	pick_new_direction()

func pick_new_direction():
	is_moving = randf() > 0.3  # 70% chance to move, 30% idle
	if is_moving:
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		move_timer = randf_range(0.5, 2.0)
	else:
		move_direction = Vector2.ZERO
		idle_timer = randf_range(0.5, 1.5)

func _physics_process(delta: float) -> void:
	if is_moving:
		move_timer -= delta
		velocity = move_direction * speed
		if move_timer <= 0:
			pick_new_direction()
	else:
		idle_timer -= delta
		velocity = Vector2.ZERO
		if idle_timer <= 0:
			pick_new_direction()
	
	move_and_slide()
	
	# flip on wall collision
	if get_slide_collision_count() > 0:
		move_direction = move_direction.bounce(get_slide_collision(0).get_normal())
		move_timer = randf_range(0.5, 1.5)
	
	if velocity.length() > 0.1:
		$sprite.play("walk")
	else:
		$sprite.stop()
		$sprite.play("default")
	
	var angle = fmod($sprite.rotation_degrees, 360)
	if angle < 0: angle += 360
	$sprite.flip_v = angle > 90 and angle < 270
	
	if is_moving:
		var target = velocity.angle()
		$sprite.rotation = lerp_angle($sprite.rotation, target, delta * 5)

func hurt(damage):
	health -= damage
	if health <= 0:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self and body.has_method("hurt"):
		body.hurt(20)
