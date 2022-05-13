extends CPUParticles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dead_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dead_time += delta
	if dead_time > 2.0:
		queue_free()
	
	modulate = modulate - Color(0, 0, 0, (1 / 2.0) * delta)
