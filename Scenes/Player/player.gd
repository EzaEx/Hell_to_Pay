extends "../Being/being.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var cam_towards_mouse := 50;
onready var cam_pos = $cam_pos;

var dead := false
var dead_timer = 0;
var score = 0;

var grapple_alive = -1

export var rotation_speed = 10;

export(NodePath) var gun_path
var gun

export(NodePath) var move_stick_path
onready var move_stick := get_node(move_stick_path)

export(NodePath) var aim_stick_path
onready var aim_stick := get_node(aim_stick_path)

onready var grapple = $grapple_node/grapple

var teleport_time = OS.get_unix_time()

var gun_item = preload("res://Scenes/GunItem/GunItem.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# handle movement here
func _physics_process(delta):
	
	if grapple_alive > 0:
		grapple.points[0] = global_position
		grapple_alive -= delta
		if grapple_alive < 0:
			grapple.points = PoolVector2Array([])
			grapple_alive = -1
			
	
	if not dead:
		var force := Vector2.ZERO;

		force = move_stick.move_vector

		if force != Vector2.ZERO and not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Walk_Down")
		elif force == Vector2.ZERO and $AnimationPlayer.is_playing():
			$AnimationPlayer.stop()

		apply_force(force)
		
		
		var aim_vec = aim_stick.move_vector
		if aim_vec != Vector2.ZERO:
			var new_transform = Transform2D(Vector2(1,0).angle_to(aim_vec), position)
			transform = transform.interpolate_with(new_transform, rotation_speed * delta)
		
		var damage = 0
		if aim_vec != Vector2.ZERO:
			if gun:
				var damaged = gun.try_fire()
				if damaged:
					damage = damaged
					
		_move_camera(damage, aim_vec);
		
		get_parent().get_node("UI/pickup_button").modulate = Color(1, 0, 0, 80 / 255.0)
		for area in $hitbox.get_overlapping_areas():
			if "pickup" in area.get_groups():
				get_parent().get_node("UI/pickup_button").modulate = Color(0.5, 1, 0.5, 0.9)
				break
				
		get_parent().get_node("UI/grapple_button").modulate = Color(1, 0, 0, 80 / 255.0)
		var facing = global_position + Vector2(250, 0).rotated(rotation)
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, facing) 

		if (result):
			get_parent().get_node("UI/grapple_button").modulate = Color(0.5, 1, 0.5, 0.9)
		

	else: #death cycles
		dead_timer += delta
		if dead_timer > 5:	
			get_tree().change_scene("res://Scenes/Menu/Title.tscn")

		get_parent().get_node("UI/static").modulate.a = dead_timer / 4

		$cam_pos/camera.zoom += Vector2.ONE * delta / 10

		cam_pos.get_node("camera").set_offset(Vector2( \
		rand_range(-1.0, 1.0) * 5, \
		rand_range(-1.0, 1.0) * 5 \
	))
	
	
func _move_camera(damage, aim_point):
	
	
	var cam_dest = global_position + aim_point * cam_towards_mouse;
	
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var result = space_state.intersect_ray(global_position, cam_dest)
	
	if result:
		cam_dest = result.position
	
	
	cam_pos.global_transform = Transform2D(0, cam_dest)
	if gun and gun.screen_shake:
		cam_pos.get_node("camera").set_offset(Vector2( \
			rand_range(-1.0, 1.0) * damage, \
			rand_range(-1.0, 1.0) * damage \
		))
		


func _unhandled_input(event):
	if not dead:
		if event.is_action_pressed("ui_accept"):
			damage(10);
			print_debug("Hurt for 10!")
			
			
		if event.is_action_pressed("pickup"):
			for area in $hitbox.get_overlapping_areas():
				if "pickup" in area.get_groups():
					
					if gun:
						var packed_gun = PackedScene.new()
						packed_gun.pack(gun)
						var itemInst = gun_item.instance()
						itemInst.gun = packed_gun
						itemInst.global_position = global_position
						get_parent().add_child(itemInst)
						
						gun.queue_free()
						var gun_inst = area.pick_up()
						add_child(gun_inst)
						gun = gun_inst
					else:
						
						var gun_inst = area.pick_up()
						add_child(gun_inst)
						gun = gun_inst
						
						if gun.get_name() == "Lasergun":
							gun.add_to_group("orange_bullets")
					
					break
					

		if event.is_action_pressed("teleport"):
			if ((OS.get_unix_time() - teleport_time) < 2):
				return 
			var floor_tiles = get_parent().get_node("Level").get_node("floor_tile")
			var wall_tiles = get_parent().get_node("Level").get_node("wall_tiles")
			var position = floor_tiles.world_to_map(get_global_mouse_position())
			
			if (floor_tiles.get_cellv(position) != -1 and wall_tiles.get_cellv(position) != 0):
				global_position = get_global_mouse_position() 
				teleport_time = OS.get_unix_time()


		if event.is_action_pressed("hook"):
			var facing = global_position + Vector2(250, 0).rotated(rotation)
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_ray(global_position, facing) 
			if result:
				velocity = position.direction_to(result.position) * 1200
				move_and_slide(velocity, Vector2(0, 0), false, 2);
				grapple.points = PoolVector2Array([global_position, result.position])
				grapple_alive = 0.25
				

func _on_Player_game_over():
	dead = true

