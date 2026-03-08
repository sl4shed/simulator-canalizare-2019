extends Node2D

var rng = RandomNumberGenerator.new()
var last_room = null
var room_count = 0

func _ready() -> void:
	await add_custom_room("res://scenes/rooms/room_1.tscn")
	await add_room()
	await add_room()
	await add_room()
	
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
	var dir = DirAccess.open("res://scenes/rooms/random")
	var files = []
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if file.ends_with(".tscn"):
			files.append("res://scenes/rooms/random/" + file)
		file = dir.get_next()
	dir.list_dir_end()
	
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
		var exit = last_room.get_node("exit")  # get fresh ref for debug only

		# rotate around entrance point instead of room origin
		var rot_diff = exit_rot - entrance.global_rotation + entrance.rotation

		var entrance_pos = entrance.global_position
		room.global_position = entrance_pos + (room.global_position - entrance_pos).rotated(rot_diff)
		#room.global_rotation += rot_diff
		await get_tree().process_frame
		room.global_position += exit_pos - entrance.global_position
	last_room = room
