extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time_passed := 0.0
var start_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	position.y = start_pos.y + sin(time_passed * 4) * 7
	$shadow.position.y = -sin(time_passed * 4) * 7 + 16


func _on_Area2D_body_entered(body):
	if "player" in body.get_groups():
		body.heal(333)
		queue_free()
