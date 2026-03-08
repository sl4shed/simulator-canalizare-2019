extends CharacterBody2D

@export var movement_paused = false
@export var speed = 800
@export var acceleration = 8.0
@export var bullets = {
	"pistol": 50,
	"magnum": 50,
	"shotgun": 50,
	"flamethrower": 50
}

@export var health = 100
@export var infection = 0

func _input(event: InputEvent) -> void:
	if movement_paused: return
	if event.is_action_pressed("shoot") and $hand.get_child_count() > 0 and $hand.get_child(0).has_method("fire"):
		$hand.get_child(0).fire(self)

func get_movement_input() -> Vector2:
	if movement_paused: return Vector2.ZERO
	if get_global_mouse_position().distance_to(position) > 50:
		look_at(get_global_mouse_position())
		if Input.get_axis("down", "up"):
			return transform.x * Input.get_axis("down", "up") * speed
		if Input.get_axis("left", "right"):
			return transform.y * Input.get_axis("left", "right") * speed
	return Vector2.ZERO

func _physics_process(delta):
	if movement_paused: return
	var target_velocity = get_movement_input()
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	if velocity.length() > 0.5:
		$sprite.play("walk")
	else:
		$sprite.stop()
		$sprite.play("default")
	move_and_slide()
	
	infection = max(infection - 0.01, 0)

func hurt(damage, infect):
	health -= damage
	infection += infect
	
	#todo ui bar
