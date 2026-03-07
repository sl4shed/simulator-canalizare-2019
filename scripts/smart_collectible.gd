extends Node2D

func _ready() -> void:
	var player = GameManager.get_player()
	var items = player.get_node("ui/inventory").list_items()
	var bullets = player.bullets
	
	
	
