extends Control

signal line_finished

@onready var player = GameManager.get_player()
var lerp_character = false
var lerp_text = false
var wait_for_input = false
var char
var char_scale

func initialize():
	player.get_node("ui").visible = false
	player.movement_paused = true

func finish():
	player.get_node("ui").visible = true
	player.movement_paused = false

func line(text: String, voice_line_path: String, character: String, character_name: String, anim):
	for ch in $panel/characters.get_children():
		ch.visible = false
	char = $panel/characters.get_node(character)
	char.visible = true
	if anim:
		char_scale = char.scale.x
		char.scale = Vector2(char_scale, 0)
		lerp_character = true
	
	$panel/text.text = "[b]%s:[/b]\n%s" % [character_name, text]
	$panel/text.visible_ratio = 0
	lerp_text = true
	
	var audio = load(voice_line_path)
	$audio.stream = audio
	$audio.play()
	await $audio.finished
	wait_for_input = true
	$panel/continue.visible = true

func _process(delta: float) -> void:
	if lerp_character:
		char.scale = lerp(char.scale, Vector2(char_scale, char_scale), delta * 20)
		if char.scale.y > 0.99:
			char.scale.y = 1
			lerp_character = false
	
	if lerp_text:
		$panel/text.visible_ratio = lerp($panel/text.visible_ratio, 1.0, delta)
		if $panel/text.visible_ratio > 0.9:
			$panel/text.visible_ratio = 1
			lerp_text = false
	 
	if wait_for_input and Input.is_action_pressed("use"):
		wait_for_input = false
		$panel/text.text = ""
		$panel/continue.visible = false
		line_finished.emit()
