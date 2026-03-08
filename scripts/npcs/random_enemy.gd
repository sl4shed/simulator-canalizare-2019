extends Node2D

var enemies = {
	"cockroach": "res://scenes/npcs/cockroach.tscn",
	"rat": "res://scenes/npcs/rat.tscn",
	"snail": "res://scenes/npcs/snail.tscn",
	"spider": "res://scenes/npcs/spider.tscn"
}

func spawn() -> void:
	var options = enemies.keys() + ["none"]
	var pick = options[randi() % options.size()]
	if pick != "none":
		var enemy = load(enemies[pick]).instantiate()
		get_tree().root.get_child(2).add_child(enemy)
		enemy.global_position = global_position
		queue_free()
