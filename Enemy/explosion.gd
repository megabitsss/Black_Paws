extends Sprite2D

	
func _ready():
	var anim_list = $AnimationPlayer.get_animation_list()
	var random_index = randi() % anim_list.size()-1
	var random_anim = anim_list[random_index]
	$AnimationPlayer.play(random_anim)
	
#set Z index to 1 to be infront of a ice speard

func _on_animation_player_animation_finished(anim_name):
	queue_free()
