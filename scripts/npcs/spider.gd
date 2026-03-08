extends CharacterBody2D
var player = null
@export var health = 40
@export var speed = 120
@export var sides = 6  # hexagon, change for different shapes
var current_side = 0
var side_timer = 0.0
@export var side_duration = 0.8

func _ready():
	player = GameManager.get_player()
	set_next_direction()

func set_next_direction():
	var angle = (TAU / sides) * current_side
	move_direction = Vector2.RIGHT.rotated(angle)
	current_side = (current_side + 1) % sides
	side_timer = side_duration

var move_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	side_timer -= delta
	if side_timer <= 0:
		set_next_direction()
	
	velocity = move_direction * speed
	move_and_slide()
	
	# bounce off walls and restart pattern
	if get_slide_collision_count() > 0:
		move_direction = move_direction.bounce(get_slide_collision(0).get_normal())
		set_next_direction()
	
	if velocity.length() > 0.1:
		$sprite.play("walk")
	else:
		$sprite.stop()
		$sprite.play("default")
	
	var angle = fmod($sprite.rotation_degrees, 360)
	if angle < 0: angle += 360
	$sprite.flip_v = angle > 90 and angle < 270
	
	var target = velocity.angle()
	$sprite.rotation = lerp_angle($sprite.rotation, target, delta * 8)

func hurt(damage):
	health -= damage
	if health <= 0:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self and body.has_method("hurt"):
		body.hurt(30)
