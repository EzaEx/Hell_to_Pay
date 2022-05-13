extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (NodePath)var music_btn_path
onready var music_btn = get_node(music_btn_path)

var score_file = "user://hell_to_pay_highscore.txt"
var highscore = 0

var sounds=[]

var music_state = true

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	sounds.append(preload("res://Assets/song_1.mp3"))
	sounds.append(preload("res://Assets/song_2.mp3"))
	sounds.append(preload("res://Assets/song_3.mp3"))
	
	$AudioStreamPlayer.stream = rand_from_list(sounds)
	$AudioStreamPlayer.play()
	
	var f = File.new()
	if f.file_exists(score_file):
		f.open(score_file, File.READ)
		var content = f.get_as_text()
		highscore = int(content)
		f.close()
		
	$UI/highscore.text = "High Score: " + str(highscore)
	$UI/highscore.show()
	$score_timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func rand_from_list(list):
	return list[randi() % len(list)]



func _on_score_timer_timeout():
	if $UI/highscore.visible:
		$UI/highscore.hide()
	


func _on_Player_game_over():
	
	if $Player.score > highscore:
		highscore = $Player.score
		var f = File.new()
		f.open(score_file, File.WRITE)
		f.store_string(str(highscore))
		f.close()
	
		$UI/highscore.text = "New High Score: " + str(highscore)
		$UI/highscore.show()
		$score_timer.start()
	
	else:
		$UI/highscore.text = "You Scored: " + str($Player.score) + "\nHigh Score: " + str(highscore) 
		$UI/highscore.show()
		$score_timer.start()


func _on_pause_button_pressed():
	get_tree().paused = true
	$UI/pause_screen.show()


func _on_resume_button_pressed():
	$UI/pause_screen.hide()
	get_tree().paused = false


func _on_quit_button_pressed():
	get_tree().queue_delete(get_tree())
	get_tree().quit()


func _on_music_button_pressed():
	if music_state:
		music_btn.modulate = Color(1, 0, 0)
		$AudioStreamPlayer.stop()
		music_state = false
	else:
		music_btn.modulate = Color(0, 1, 0)
		$AudioStreamPlayer.play()
		music_state = true
