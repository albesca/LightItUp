extends Control


signal play_sound(sound)
signal back_to_menu(node_item)


func mouse_entered():
	emit_signal("play_sound", 'enter')


func mouse_exited():
	emit_signal("play_sound", 'exit')


func close_menu():
	emit_signal("play_sound", 'press')
	emit_signal("back_to_menu", self)
