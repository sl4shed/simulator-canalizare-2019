extends Node

func _ready():
	pass

func get_player() -> Node2D:
	return get_tree().root.get_child(2).get_node("player")
