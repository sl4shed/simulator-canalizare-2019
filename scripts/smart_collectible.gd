extends Node2D

var weapons = {
	"axe":     { "value": 3, "type": "melee" },
	"pistol":  { "value": 8, "type": "gun", "ammo": "pistol" },
	"shotgun": { "value": 1, "type": "gun", "ammo": "shotgun" },
	"magnum":  { "value": 1, "type": "gun", "ammo": "magnum" },
}

const LOW_AMMO_THRESHOLD = 5

func _to_scene_path(result: String) -> String:
	if result.ends_with("_ammo"):
		var ammo_type = result.replace("_ammo", "")
		return "res://scenes/ammo/%s.tscn" % ammo_type
	else:
		return "res://scenes/weapons/%s.tscn" % result

func initialize() -> void:
	var player = GameManager.get_player()
	var items = player.get_node("ui/inventory").list_items()
	var bullets = player.bullets
	
	var result = pick_collectible(items, bullets)
	if result != "empty":
		var path = _to_scene_path(result)
		var collectible = preload("res://scenes/collectible.tscn")
		var col = collectible.instantiate()
		col.item_scene = load(path)
		add_child(col)
	
func pick_collectible(items, bullets) -> String:
	var player_guns = []
	var player_has_axe = false
	
	for item in items:
		if item.get("type") == "axe":
			player_has_axe = true
		elif item.get("gun_type") != null:
			player_guns.append(item.gun_type)
	
	# low ammo
	for gun in player_guns:
		var ammo_key = weapons[gun].get("ammo", gun)
		if bullets.get(ammo_key, 0) < LOW_AMMO_THRESHOLD:
			return ammo_key + "_ammo"
	
	var has_guns = player_guns.size() > 0
	var has_ammo = false
	for gun in player_guns:
		var ammo_key = weapons[gun].get("ammo", gun)
		if bullets.get(ammo_key, 0) >= LOW_AMMO_THRESHOLD:
			has_ammo = true
			break
	
	var pool = []
	
	if not has_guns:
		# no guns
		for name in weapons:
			var w = weapons[name]
			for i in range(w.value):
				pool.append(name)
	elif has_guns and has_ammo:
		# 75% ammo 25% guns
		for i in range(3):
			pool.append(_pick_ammo(player_guns, bullets))
		pool.append(_pick_gun(player_guns))
	elif has_guns and not has_ammo:
		# 75% ammo 25% empty
		for i in range(3):
			pool.append(_pick_ammo(player_guns, bullets))
		pool.append("empty")
	else:
		# no guns no ammo
		for i in range(3):
			pool.append(_pick_gun([]))
		pool.append("empty")
	
	pool.shuffle()
	return pool[0]

func _pick_ammo(player_guns, bullets) -> String:
	# prefer ammo for guns with least bullets
	var sorted = player_guns.duplicate()
	sorted.sort_custom(func(a, b):
		var ka = weapons[a].get("ammo", a)
		var kb = weapons[b].get("ammo", b)
		return bullets.get(ka, 0) < bullets.get(kb, 0)
	)
	return weapons[sorted[0]].get("ammo", sorted[0]) + "_ammo"

func _pick_gun(exclude: Array) -> String:
	# exclude owned guns
	var pool = []
	for name in weapons:
		if name not in exclude:
			for i in range(weapons[name].value):
				pool.append(name)
	if pool.is_empty():
		return weapons.keys()[randi() % weapons.size()]
	pool.shuffle()
	return pool[0]
