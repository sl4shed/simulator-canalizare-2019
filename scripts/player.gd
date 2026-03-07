extends CharacterBody2D

@export var speed = 800
@export var acceleration = 8.0

@export var bullets = {
	"pistol": 0,
	"magnum": 0,
	"shotgun": 50,
	"flamethrower": 0
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and $hand.get_child_count() > 0 and $hand.get_child(0).has_method("fire"):
		$hand.get_child(0).fire(self)

func get_movement_input() -> Vector2:
	if get_global_mouse_position().distance_to(position) > 50:
		look_at(get_global_mouse_position())
		if Input.get_axis("down", "up"):
			return transform.x * Input.get_axis("down", "up") * speed
		if Input.get_axis("left", "right"):
			return transform.y * Input.get_axis("left", "right") * speed
	return Vector2.ZERO

func _physics_process(delta):
	var target_velocity = get_movement_input()
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	if abs(velocity.x) > 0.1 or abs(velocity.y):
		$sprite.play("walk")
	else:
		$sprite.play("default")
	move_and_slide()
