extends Button

signal click_end()

func _on_mouse_entered(): #sound when mouse passes through this button
	$snd_hover.play()

func _on_pressed():
	$snd_click.play()
	emit_signal("click_end")
