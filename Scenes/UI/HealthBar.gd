extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var target_path
onready var target = get_node(target_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var health = target.health
	value = health
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_game_over():
	queue_free()
