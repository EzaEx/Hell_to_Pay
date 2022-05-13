extends TouchScreenButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var is_left = true
var this_index = -1

var move_vector := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):

	if event is InputEventScreenTouch and event.pressed and this_index == -1  and (is_left and event.position.x <= 360 or (not is_left) and event.position.x > 360):
		this_index = event.index
	
	if (event is InputEventScreenTouch or event is InputEventScreenDrag) and event.index == this_index:
		var text_centre = position + Vector2.ONE * 128
		var sprite_pos = event.position - position / 2
		
		if (Vector2.ONE * 64 - sprite_pos).length() < 64:
			
			#sprite_pos = text_centre - (text_centre - sprite_pos).normalized() * 128
			$Sprite.position = sprite_pos
		else:
			$Sprite.position = Vector2.ONE * 64 - (Vector2.ONE * 64 - sprite_pos).normalized() * 64
		#$Sprite.position = sprite_pos
		move_vector = calculate_move_vec(event.position * 2)
	
	if event is InputEventScreenTouch and not event.pressed and event.index == this_index:
		$Sprite.position = Vector2.ONE * 64
		move_vector = Vector2.ZERO
		this_index = -1
			
			

func calculate_move_vec(event_pos):
	var text_centre = position + Vector2.ONE * 128
	var result_vector = (event_pos - text_centre) / 128
	
	if result_vector.length() > 1:
		 result_vector = result_vector.normalized()
		
	return result_vector
