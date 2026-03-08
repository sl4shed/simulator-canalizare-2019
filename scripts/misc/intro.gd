extends Control

var step = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		step += 1
		$"1".visible = step >= 1
		$"2".visible = step >= 2
		$"3".visible = step >= 3
		if step > 3:
			get_tree().change_scene_to_file("res://scenes/main.tscn")
