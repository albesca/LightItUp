extends Spatial


signal back_to_menu
signal next_level
signal play_sound

var done = false
var passed = false
var has_next = true


func _process(_delta):
	if passed:
		$LevelMenu/HBoxContainer/VBoxContainer/NextButton.visible = true

	if done:
		if !has_next:
			$Label.text = 'Thanks for playing!'

		$Label.visible = true


func back_to_menu():
	emit_signal("play_sound", 'press')
	emit_signal("back_to_menu")


func next_level():
	emit_signal("play_sound", 'press')
	emit_signal("next_level")


func mouse_entered():
	emit_signal("play_sound", 'enter')


func mouse_exited():
	emit_signal("play_sound", 'exit')
