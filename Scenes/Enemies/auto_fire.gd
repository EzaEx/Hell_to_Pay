extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(NodePath) var gun_path
onready var gun = get_node(gun_path)

var last_fire = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	last_fire += delta
	
	if last_fire > 30:
		get_parent().queue_free()
	
	if gun.can_fire():
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var result = space_state.intersect_ray(global_position, get_parent().player.global_position)
		if result and "player" in result.collider.get_groups():
			gun.try_fire()
			last_fire = 0
	
