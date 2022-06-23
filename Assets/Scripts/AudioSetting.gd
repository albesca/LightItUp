extends Control


signal play_sound(sound)
signal close_audio_settings(node)


func _ready():
	$HBoxContainer/VBoxContainer/AudioContainer/Volume.value = \
			db2linear(AudioServer.get_bus_volume_db(1))
	$HBoxContainer/VBoxContainer/MusicContainer/Volume.value = \
			db2linear(AudioServer.get_bus_volume_db(2))
	$HBoxContainer/VBoxContainer/AudioContainer/Toggle.pressed = \
			!AudioServer.is_bus_mute(1)
	$HBoxContainer/VBoxContainer/MusicContainer/Toggle.pressed = \
			!AudioServer.is_bus_mute(2)


func toggle_sounds(button_pressed):
	AudioServer.set_bus_mute(1, !button_pressed)
	if button_pressed:
		$SampleSound.play()


func toggle_music(button_pressed):
	AudioServer.set_bus_mute(2, !button_pressed)


func back_to_menu():
	emit_signal("play_sound", 'press')
	emit_signal("close_audio_settings", self)


func change_sound_volume(value):
	AudioServer.set_bus_volume_db(1, linear2db(value))
	$SampleSound.play()
	if AudioServer.is_bus_mute(1):
		AudioServer.set_bus_mute(1, false)
		$HBoxContainer/VBoxContainer/AudioContainer/Toggle.pressed = true


func change_music_volume(value):
	emit_signal("play_sound", 'press')
	AudioServer.set_bus_volume_db(2, linear2db(value))
	if AudioServer.is_bus_mute(2):
		AudioServer.set_bus_mute(2, false)
		$HBoxContainer/VBoxContainer/MusicContainer/Toggle.pressed = true


func mouse_entered():
	emit_signal("play_sound", 'enter')


func mouse_exited():
	emit_signal("play_sound", 'exit')
