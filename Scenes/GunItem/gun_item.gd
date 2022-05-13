extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var gun;
var time_passed := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = gun.instance().get_node("sprite").texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	$Sprite.position.y = sin(time_passed * 4) * 5
	$shadow.position.y = -sin(time_passed * 4) * 5 + 19
	
	
func pick_up():
	var gun_instance = gun.instance()
	queue_free()
	return gun_instance
