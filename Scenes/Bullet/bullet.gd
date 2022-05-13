extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time_alive := 0.0;
var death_time := 5.0;
var damage = 5;
var speed = 10;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	time_alive += delta
	if time_alive > death_time:
		queue_free()
		return
		
	self.position += Vector2(1, 0).rotated(rotation) * speed;
	
	

func _on_hitbox_body_entered(body):
	
	if body.has_method("damage"):
		body.damage(damage)
	
	queue_free()
	return
	
