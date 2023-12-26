extends Control

@onready var sprite = $AnimatedSprite2D
@onready var snd = $MenuSoundtrack

var level = "res://World/world.tscn"

func _ready():
	sprite.play()
	snd.play()

func _on_button_play_click_end():
	var _level = get_tree().change_scene_to_file(level)
	
func _on_button_exit_click_end(): #we receive "click_end" signal from a node "button_exit"
	get_tree().quit()
	
