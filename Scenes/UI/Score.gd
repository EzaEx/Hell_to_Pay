extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var target_path
onready var target = get_node(target_path)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var score = target.score
	set_text("Score: " + str(score))
	
func _on_Player_game_over():
	queue_free()
