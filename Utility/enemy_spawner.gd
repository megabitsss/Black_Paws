extends Node2D

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

signal win

var time = 0

func _ready():
	connect("win", Callable(player, "win_start"))

func _on_timer_timeout(): #ปกติ spawn วิละ 1 ตัว ถ้าเพิ่มไปคือ additional
	time += 1
	if time >= 420:
		print("finished")
		emit_signal("win")
	var enemy_spawns = spawns #in the array
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end: #if it's in the range
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else: #>=
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy #load(str(i.enemy.resource_path)) no need to load, it has alrd been loaded in export inspector menu
				var counter = 0
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()	
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn) #we put this node to world scene, so it basically adds enemy to be a child of world	
					counter += 1
		
func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4) #get the size of a viewport as a vector
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2) 
	var pos_side = ["up", "down", "right", "left"].pick_random()	
	var spawn_pos1 = Vector2.ZERO	
	var spawn_pos2 = Vector2.ZERO
	match pos_side: #picking linear side
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
			
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	
	return Vector2(x_spawn, y_spawn)
