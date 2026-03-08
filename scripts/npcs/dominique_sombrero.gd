extends Node2D

@export var health = 40
@onready var player = GameManager.get_player()
@export var hurt_sounds = [
	preload("res://sounds/sfx/bunici/au.wav"),
	preload("res://sounds/sfx/bunici/ioi.wav"),
	preload("res://sounds/sfx/bunici/jalele.wav"),
]
var is_hovered = false
var disabled = false

func _process(delta: float) -> void:
	var target = $sprite.global_position.direction_to(player.position).angle() - 1.57079633 # 90 deg in radians im too lazy to use deg2rad
	$sprite.rotation = lerp_angle($sprite.rotation, target, delta * 2)
	
	# hover and click code
	var mouse = get_global_mouse_position()
	var dist = mouse.distance_to($sprite.global_position)
	var hovered = dist < 50  # adjust radius
	if hovered != is_hovered:
		is_hovered = hovered
		if hovered and not $ui.visible and not disabled:
			$sprite.material.set_shader_parameter("color", Color.WHITE)
			$text.visible = true
		else:
			$sprite.material.set_shader_parameter("color", Color.TRANSPARENT)
			$text.visible = false
	
	if is_hovered and Input.is_action_pressed("use") and not $ui.visible and not disabled:
		$ui.visible = true
		$ui/dialog.initialize()
		$sprite.material.set_shader_parameter("color", Color.TRANSPARENT)
		$text.visible = false
		$ui/dialog.line("Ola niño, cum ai ajuns tu la mine in canalizare?", "res://sounds/voice lines/bunici/canalizare.wav", "dominique", "Dominique", true)
		await $ui/dialog.line_finished
		$ui/dialog.line("M-am impiedicat, ce pot sa zic?", "res://sounds/voice lines/player/m-am impiedicat.wav", "player", "Cabral Catarama", true)
		await $ui/dialog.line_finished
		$ui/dialog.line("Sigur ba... Dar vezi unpic ba... Aaa.. Ai grija unpic ba... Ca am vazut un musculoi muschiulos pe aici pe undeva... Sa nu te manance cumva!", "res://sounds/voice lines/bunici/musculoi muschiulos.wav", "dominique", "Dominique", true)
		await $ui/dialog.line_finished
		$ui/dialog.line("Da, da, bine... Sigur ma... Ma mananca o musca...", "res://sounds/voice lines/player/ma mananca o musca.wav", "player", "Cabral Catarama", true)
		await $ui/dialog.line_finished
		$ui/dialog.finish()
		$ui.visible = false
		disabled = true

func hurt(damage):
	health -= damage
	var index = randi_range(0, 2)
	$hurt.stream = hurt_sounds[index]
	
	if health <= 0:
		$hurt.set_script(preload("res://scripts/misc/break.gd"))
		var hr = $hurt
		remove_child(hr)
		get_tree().root.add_child(hr)
		hr.play()
		queue_free()
	else:
		$hurt.play()
			
