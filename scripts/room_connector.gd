extends Node2D

var rng = RandomNumberGenerator.new()
var last_room = null
var room_count = 0

func _ready() -> void:
	await add_custom_room("res://scenes/rooms/room_1.tscn")
	for i in range(0, 49):
		await add_room()
	await add_custom_room("res://scenes/rooms/bossfight.tscn")
	
	for room in get_children():
		for node in room.get_children():
			if node.has_method("spawn"):
				node.spawn()
	
	$ui.visible = false
	
	
func add_custom_room(path) -> void:
	# store BEFORE instantiating new room
	var exit_pos = null
	var exit_rot = null
	if last_room != null:
		exit_pos = last_room.get_node("exit").global_position
		exit_rot = last_room.get_node("exit").global_rotation
	
	var room = load(path).instantiate()
	add_child(room)
	await get_tree().process_frame
	
	if exit_pos != null:
		var entrance = room.get_node("entrance")
		room.global_position += exit_pos - entrance.global_position
	
	last_room = room

func add_room() -> void:
	var files = [
		"res://scenes/rooms/random/room_2.tscn",
		"res://scenes/rooms/random/room_3.tscn",
		"res://scenes/rooms/random/room_4.tscn",
		"res://scenes/rooms/random/room_5.tscn",
		"res://scenes/rooms/random/room_6.tscn",
	]

	if files.is_empty():
		return

	# store BEFORE instantiating new room
	var exit_pos = null
	var exit_rot = null
	if last_room != null:
		exit_pos = last_room.get_node("exit").global_position
		exit_rot = last_room.get_node("exit").global_rotation

	var path = files[rng.randi() % files.size()]
	var room = load(path).instantiate()
	add_child(room)
	await get_tree().process_frame
	
	if exit_pos != null:
		var entrance = room.get_node("entrance")
		var exit = last_room.get_node("exit")
		var rot_diff = exit_rot - entrance.global_rotation + entrance.rotation
		var entrance_pos = entrance.global_position
		room.global_position = entrance_pos + (room.global_position - entrance_pos).rotated(rot_diff)
		await get_tree().process_frame
		room.global_position += exit_pos - entrance.global_position
	last_room = room
