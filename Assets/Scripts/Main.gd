extends Spatial


var levels = {
	1: {
		'name': 'Level 1',
		'passed': false,
		'resource': load("res://Assets/Scenes/Levels/Level01.tscn")
	},
	2: {
		'name': 'Level 2',
		'passed': false,
		'resource': load("res://Assets/Scenes/Levels/Level02.tscn")
	},
	3: {
		'name': 'Level 3',
		'passed': false,
		'resource': load("res://Assets/Scenes/Levels/Level03.tscn")
	},
	4: {
		'name': 'Level 4',
		'passed': false,
		'resource': load("res://Assets/Scenes/Levels/Level04.tscn")
	},
	5: {
		'name': 'Level 5',
		'passed': false,
		'resource': load("res://Assets/Scenes/Levels/Level05.tscn")
	}
}
var levels_menu_scene = load("res://Assets/Scenes/LevelsMenu.tscn")
var how_to_menu_scene = load("res://Assets/Scenes/HowToMenu.tscn")
var audio_settings_scene = load("res://Assets/Scenes/AudioSettings.tscn")
var credits_scene = load("res://Assets/Scenes/CreditsMenu.tscn")
var selected_level = -1


func _ready():
	select_next_level()


func select_next_level():
	for level in levels.keys():
		if !levels[level]['passed']:
			selected_level = level
			break
		elif selected_level == -1:
			selected_level = level
	
	update_level_label()


func update_level_label():
	if selected_level in levels.keys():
		$Menu/HBoxContainer/VBoxContainer/LevelLabel.text = \
				levels[selected_level]['name']


func choose_level():
	$AudioStreamPlayer.stream = Global.button_sounds['press']
	$AudioStreamPlayer.play()
	$Menu.visible = false
	var levels_menu = levels_menu_scene.instance()
	var levels_list = []
	for level in levels.keys():
		levels_list.append(levels[level])
	
	levels_menu.init(levels_list)
	add_child(levels_menu)
	levels_menu.connect('back_to_menu', self, 'close_levels_menu')
	levels_menu.connect('play_sound', self, 'play_sound')


func close_levels_menu(levels_menu, new_level):
	$Menu.visible = true
	selected_level = new_level
	update_level_label()
	levels_menu.visible = false


func start_level():
	$Menu.visible = false
	var level = levels[selected_level]['resource'].instance()
	level.level_id = selected_level
	var has_next = (selected_level + 1) in levels.keys()
	level.init(levels[selected_level]['passed'], has_next)
	add_child(level)
	level.connect('back_to_menu', self, 'back_to_menu')
	level.connect('level_done', self, 'level_passed')
	level.connect('play_sound', self, 'play_sound')


func back_to_menu(level_node, start_next):
	$Menu.visible = true
	play_sound('press')
	level_node.queue_free()
	if level_node.done or start_next:
		select_next_level()

	if start_next:
		start_level()


func level_passed(level_node):
	if level_node.done:
		levels[level_node.level_id]['passed'] = true


func button_mouse_entered():
	play_sound('enter')


func button_mouse_exited():
	play_sound('exit')


func start_pressed():
	play_sound('press')
	start_level()


func play_sound(sound):
	$AudioStreamPlayer.stream = Global.button_sounds[sound]
	$AudioStreamPlayer.play()


func open_how_to_menu():
	$AudioStreamPlayer.stream = Global.button_sounds['press']
	$AudioStreamPlayer.play()
	$Menu.visible = false
	var how_to_menu = how_to_menu_scene.instance()
	add_child(how_to_menu)
	how_to_menu.connect('back_to_menu', self, 'close_how_to_menu')
	how_to_menu.connect('play_sound', self, 'play_sound')


func close_how_to_menu(menu):
	$Menu.visible = true
	menu.queue_free()


func open_audio_settings():
	$AudioStreamPlayer.stream = Global.button_sounds['press']
	$AudioStreamPlayer.play()
	$Menu.visible = false
	var audio_settings = audio_settings_scene.instance()
	add_child(audio_settings)
	audio_settings.connect('close_audio_settings', self, 'close_audio_settings')
	audio_settings.connect('play_sound', self, 'play_sound')


func close_audio_settings(menu):
	$Menu.visible = true
	menu.queue_free()


func open_credits():
	$AudioStreamPlayer.stream = Global.button_sounds['press']
	$AudioStreamPlayer.play()
	$Menu.visible = false
	var credits = credits_scene.instance()
	add_child(credits)
	credits.connect('back_to_menu', self, 'close_credits')
	credits.connect('play_sound', self, 'play_sound')


func close_credits(menu):
	$Menu.visible = true
	menu.queue_free()
