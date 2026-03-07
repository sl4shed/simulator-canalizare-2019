extends CharacterBody2D

@export var speed = 2400
@export var initialDamage = 40
var despawn_time = 1

func _ready():
	despawn()

func _physics_process(delta: float) -> void:
	velocity = Vector2.DOWN.rotated(rotation) * speed
	move_and_slide()

func despawn() -> void:
	await get_tree().create_timer(despawn_time).timeout
	queue_free()
