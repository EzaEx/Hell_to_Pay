extends "../Being/being.gd"

var player
var hit_timer := -1.0

var corpse = preload("res://Scenes/Enemies/Deademy.tscn")

export var damage = 10;
export var frequency = 1


func _ready():
	pass
	
	
	 
func _process(delta):
	if hit_timer > -1:
		hit_timer -= delta
		if hit_timer < 0:
			player.damage(damage)
			hit_timer = frequency
	
	
	
# warning-ignore:unused_argument
func _physics_process(delta):
	
	var force = player.global_position - global_position
	force = force.normalized()
	
	rotation = Vector2(1, 0).angle_to(force)
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("Walk")
	apply_force(force)
	
func _die():
	
	var corp = corpse.instance()
	
	get_parent().add_child(corp)
	
	corp.global_transform = global_transform
	
	player.score +=1
	._die()


func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.damage(damage)
		hit_timer = frequency


func _on_hitbox_body_exited(body):
	if body.is_in_group("player"):
		hit_timer = -1
