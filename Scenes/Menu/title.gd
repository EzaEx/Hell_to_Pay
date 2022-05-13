extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var runs_file = "user://hell_to_pay_runs.txt"
var runs = 0

var fail_load = false
var wait_loop = false
var ad_run = false
var wait_time = rand_range(0.5, 1.5)
var desmond_the_variable := 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$load_indic.hide()
	$support_msg.hide()
	
	var f = File.new()
	
	if f.file_exists(runs_file):
		f.open(runs_file, File.READ)
		var content = f.get_as_text()
		runs = int(content)
	else:
		runs = 0
		f.open(runs_file, File.WRITE)
		f.store_string(str(runs))
		
	f.close()
	
	$run_no.text = "runs: " + str(runs)
	
	#print(str(runs))
	if (runs % 2 == 1):	
		$AdMob.load_interstitial()
		pass
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wait_loop:
		wait_time -= delta
		if wait_time < 0:
			if not ad_run:
				get_tree().change_scene("res://Scenes/Main/Main.tscn")
			else:
				if $AdMob.is_interstitial_loaded():
					$AdMob.show_interstitial()
					wait_loop = false
				if fail_load or OS.get_name() == "Windows":
					
					$load_indic.hide()
					$support_msg.show()
					
					wait_loop = false
	
	elif $support_msg.is_visible():
		desmond_the_variable -= delta
		if desmond_the_variable <= 0:
			get_tree().change_scene("res://Scenes/Main/Main.tscn")



func _on_Start_Button_pressed():
	
	$static.mouse_filter = MOUSE_FILTER_STOP
	
	
	if (runs % 2 == 1):	
		#print("play")
		ad_run = true
		
	
	runs += 1
	
	var f = File.new()
	
	if f.file_exists(runs_file):
		f.open(runs_file, File.WRITE)
		f.store_string(str(runs))
	
	$load_indic.show()
	$static.modulate.a = 0.85
	wait_loop = true


func _on_Exit_Button_pressed():
	get_tree().queue_delete(get_tree())
	get_tree().quit()


func _on_Credits_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu/Credits.tscn")


func _on_Tut_Button_pressed():
	get_tree().change_scene("res://Scenes/Menu/How_To_Play.tscn")


func _on_AdMob_interstitial_closed():
	
	yield(get_tree().create_timer(0.25), "timeout")
	
	get_tree().change_scene("res://Scenes/Main/Main.tscn")


func _on_AdMob_interstitial_failed_to_load(error_code):
	fail_load = true
