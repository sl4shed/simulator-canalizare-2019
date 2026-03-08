extends CharacterBody2D

@export var speed = 2400
@export var damage = 40
var despawn_time = 1

func _ready():
	despawn()

func _physics_process(delta: float) -> void:
	velocity = Vector2.DOWN.rotated(rotation) * speed
	move_and_slide()
	if get_slide_collision_count() > 0:
		var collider = get_slide_collision(0).get_collider()
		if collider.is_in_group("bullet"): return
		if collider.has_method("hurt"):
			collider.hurt(damage)
			queue_free()
		else:
			queue_free()

func despawn() -> void:
	await get_tree().create_timer(despawn_time).timeout
	queue_free()
