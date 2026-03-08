extends CharacterBody2D
@onready var player = GameManager.get_player()
@export var health = 500
@export var speed = 150
@export var charge_speed = 500
@export var bullet_damage = 20
@export var bullet_speed = 800

var enabled = false
var bullet = preload("res://scenes/weapons/bullet.tscn")
var state = "idle"
var charge_direction = Vector2.ZERO

func _ready():
	pick_next_action()

func pick_next_action():
	if not enabled: return
	var wait = randf_range(1.5, 4.0)
	await get_tree().create_timer(wait).timeout
	if not is_instance_valid(player): return
	
	var roll = randf()
	if roll < 0.4:
		await do_shoot()
	elif roll < 0.7:
		await do_charge()
	else:
		state = "idle"
	
	pick_next_action()

func do_shoot():
	if not enabled: return
	state = "shoot"
	for child in $bullet_directions.get_children():
		var b = bullet.instantiate()
		get_tree().root.add_child(b)
		b.global_position = child.global_position
		b.rotation = child.global_rotation
		b.damage = bullet_damage
		b.speed = bullet_speed
	await get_tree().create_timer(0.5).timeout
	state = "idle"

func do_charge():
	if not enabled: return
	state = "charge"
	charge_direction = global_position.direction_to(player.global_position)
	await get_tree().create_timer(0.7).timeout
	state = "idle"

func _physics_process(delta: float) -> void:
	if not enabled: return
	if not is_instance_valid(player): return
	
	# always look at player
	var target_angle = global_position.direction_to(player.global_position).angle()
	$sprite.rotation = lerp_angle($sprite.rotation, target_angle, delta * 3)
	
	var angle = fmod($sprite.rotation_degrees, 360)
	if angle < 0: angle += 360
	$sprite.flip_v = angle > 90 and angle < 270
	
	match state:
		"idle":
			# drift slowly toward player
			var dir = global_position.direction_to(player.global_position)
			velocity = velocity.lerp(dir * speed, delta * 2)
		"charge":
			velocity = charge_direction * charge_speed
		"shoot":
			velocity = velocity.lerp(Vector2.ZERO, delta * 5)
	
	move_and_slide()
	
	if velocity.length() > 0.1:
		$sprite.play("walk")
	else:
		$sprite.play("default")

func hurt(damage):
	if not enabled: return
	health -= damage
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://scenes/thanks.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("infect"):
		enabled = true
		pick_next_action()
