extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var wait_range = Vector2(5, 10)
var wait_time = rand_range(wait_range.x, wait_range.y)
var enemies := [preload("../Enemies/ModernTank.tscn")]

export (NodePath) var player_path;
onready var player = get_node(player_path)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	wait_time -= delta
	if wait_time < 0:
		
		var new_enemy = rand_from_list(enemies).instance()
		new_enemy.player = player
		new_enemy.global_position = get_parent().global_position
		add_child(new_enemy)
		
		wait_time = rand_range(wait_range.x, wait_range.y)
	


func rand_from_list(list):
	return list[randi() % len(list)]
