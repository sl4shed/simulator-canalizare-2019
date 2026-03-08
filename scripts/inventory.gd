@tool
extends Panel
var selected = -1
var slot = preload("res://scenes/inventory_slot.tscn")
var selected_slot_texture = preload("res://assets/textures/inventory slot selected.webp")
var unselected_slot_texture = preload("res://assets/textures/inventory slot.webp")
@export var player: CharacterBody2D
		
func shake():
	for s in $slots.get_children():
		s.shake()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_inventory_up"):
		select_index(selected + 1)
	elif event.is_action_pressed("scroll_inventory_down"):
		select_index(selected - 1)
	elif event.is_action_pressed("inventory_slot_1"):
		select_index(0)
	elif event.is_action_pressed("inventory_slot_2"):
		select_index(1)
	elif event.is_action_pressed("inventory_slot_3"):
		select_index(2)
	elif event.is_action_pressed("inventory_slot_4"):
		select_index(3)
	elif event.is_action_pressed("inventory_slot_5"):
		select_index(4)
	elif event.is_action_pressed("inventory_slot_6"):
		select_index(5)
	elif event.is_action_pressed("inventory_slot_7"):
		select_index(6)
	elif event.is_action_pressed("inventory_slot_8"):
		select_index(7)
	elif event.is_action_pressed("inventory_slot_9"):
		select_index(8)
	elif event.is_action_pressed("inventory_slot_10"):
		select_index(9)

func deselect():
	if selected == -1:
		return
	var old_slot = $slots.get_child(selected)
	old_slot.get_node("slot").texture = unselected_slot_texture
	
	if player:
		for child in player.get_node("hand").get_children():
			child.queue_free()
	selected = -1

func select_index(index):
	index = clamp(index, 0, $slots.get_child_count() - 1)
	
	if index == selected:
		deselect()
		return
	
	if selected != -1:
		var old_slot = $slots.get_child(selected)
		old_slot.get_node("slot").texture = unselected_slot_texture
	
	selected = index
	var new_slot = $slots.get_child(selected)
	new_slot.get_node("slot").texture = selected_slot_texture
	
	if player:
		for child in player.get_node("hand").get_children():
			child.queue_free()
		var subviewport = new_slot.get_node("slot/viewport/subviewport")
		if subviewport.get_child_count() > 0:
			var item = subviewport.get_child(0).duplicate()
			item.position = Vector2.ZERO
			item.rotation = 0
			item.scale = Vector2(1, 1)
			item.position.x = item.initialX
			item.index = selected
			
			# item hardcoded specific code
			if item.has_node("ui"):
				item.get_node("ui").visible = true
			
			if item.has_method("update_bullet_count"):
				item.update_bullet_count(player)
			
			player.get_node("hand").add_child(item)

func remove_index(index: int):
	if index < $slots.get_child_count() and index >= 0:
		selected = -1
		$slots.get_child(index).queue_free()

func add_item(item_scene: PackedScene) -> void:
	var new_slot = slot.instantiate()
	$slots.add_child(new_slot)
	new_slot.set_item(item_scene)

func list_items() -> Array:
	var array = [];
	for slot in $slots.get_children():
		if slot.has_node("viewport/subviewport"):
			var item = slot.get_node("viewport/subviewport").get_child(0)
			
			#gun
			if item.has_method("fire"):
				array.push_back({
					"gun_type": item.ammo_type,
				})
			
			# melee
			if item.has_method("hit"):
				array.push_back({
					"type": item.type
				})
	return array
