extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


signal enemy_spawned

export var quota = 1
export var maximum = 50


export (NodePath) var player_path;
onready var player = get_node(player_path)

export (NodePath) var level_path;
onready var floor_map = get_node(level_path).get_node("floor_tile")
onready var wall_map = get_node(level_path).get_node("wall_tiles")



var enemies := [
load("res://Scenes/Enemies/Gobster.tscn"),
load("res://Scenes/Enemies/Gobster.tscn"),
load("res://Scenes/Enemies/Gobster.tscn"),
load("res://Scenes/Enemies/Gobster.tscn"),
preload("../Enemies/Grazer.tscn"),
preload("../Enemies/Grazer.tscn"),
preload("../Enemies/Grazer.tscn"),
preload("../Enemies/Grazer.tscn"),
preload("../Enemies/Glocktle.tscn"), 
preload("../Enemies/FutureTank.tscn"),
preload("../Enemies/FutureTank.tscn"), 
preload("../Enemies/ModernTank.tscn"),
preload("../Enemies/ModernTank.tscn")
]
var time_total = 0
var time_till_add = 8

# Called when the node enters the scene tree for the first time.
func _process(delta):
	
	if quota < maximum:
		time_till_add -= delta
		if time_till_add <= 0:
			quota += 1
			time_till_add = 8
	
	
	if get_child_count() < quota:
		#spawn code
		
		var pos := Vector2.ZERO
		while true:
			var dir := Vector2(1, 0).rotated(rand_range(-PI, PI))
			dir = dir.normalized()

			pos = player.global_position + dir * 450
			#pos = player.global_position
			var tile_pos = floor_map.world_to_map(pos)
			if (floor_map.get_cellv(tile_pos) != floor_map.INVALID_CELL and wall_map.get_cellv(tile_pos) == wall_map.INVALID_CELL):
				
				break
		
		var new_enemy = rand_from_list(enemies).instance()
		new_enemy.player = player
		new_enemy.global_position = pos
		add_child(new_enemy)
		emit_signal("enemy_spawned")
		




func rand_from_list(list):
	return list[randi() % len(list)]


func _on_Player_game_over():
	for child in get_children():
		child.queue_free()
	queue_free()


func _on_Despawner_body_exited(body):
	if 'enemy' in body.get_groups():
		body.queue_free()
