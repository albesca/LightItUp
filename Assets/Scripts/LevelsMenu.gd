extends Control


signal back_to_menu(menu, level)
signal play_sound(sound)

var selected_index = -1


func back_to_menu():
	emit_signal("play_sound", 'press')
	emit_signal("back_to_menu", self, selected_index)


func level_selected(index):
	selected_index = index + 1
	emit_signal("play_sound", 'press')
	emit_signal("back_to_menu", self, selected_index)


func init(levels):
	var index = 1
	var next_level_found = false
	var previous_done = true
	for level in levels:
		$HBoxContainer/VBoxContainer/LevelsList.add_item(level['name'], index)
		if !previous_done:
			$HBoxContainer/VBoxContainer/LevelsList.set_item_disabled( \
					index - 1, true)

		if !level['passed'] and previous_done:
			$HBoxContainer/VBoxContainer/LevelsList.select(index - 1)
			previous_done = false

		if !next_level_found and !level['passed']:
			next_level_found = true
			selected_index = index

		index += 1


func mouse_entered():
	emit_signal("play_sound", 'enter')


func mouse_exited():
	emit_signal("play_sound", 'exit')
