extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var fade_in_time := 2.0
export var hold_time := 3.0
export var fade_out_time := 2.0

onready var this_fit = fade_in_time
onready var this_ht = hold_time
onready var this_fot = fade_out_time

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0
	$project_label.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if this_fit > 0:
		modulate.a += delta / fade_in_time
		this_fit -= delta
	
	elif this_ht > 0:
		modulate.a = 1
		this_ht -= delta
		
		if this_ht > hold_time / 4:
			$project_label.modulate.a += delta / (hold_time / 3)
		
	elif this_fot > -0.5:
		$project_label.modulate.a = 1
		modulate.a -= delta / fade_out_time
		this_fot -= delta
	
	else:
		get_tree().change_scene("res://Scenes/Menu/Title.tscn")
