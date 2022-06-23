extends Spatial


signal back_to_menu(level_node, start_next)
signal level_done(menu, level)
signal play_sound()


var level_id = -1
var done = false
var passed = false
var has_next = false


func _ready():
	$EmptyLevel.has_next = has_next
	var blocks = get_tree().get_nodes_in_group('active')
	for block in blocks:
		block.connect('play_sound', self, 'play_sound')


func _process(_delta):
	if !done:
		var connecting_nodes = get_tree().get_nodes_in_group('connecting')
		var all_connected = false
		if len(connecting_nodes) > 0:
			all_connected = true
			for connecting_node in connecting_nodes:
				connecting_node.check_connections()
				if connecting_node.has_to_connect and !connecting_node.connected:
					all_connected = false

		if all_connected:
			done = true
			passed = true
			print("well done!")
			emit_signal("level_done", self)
			var active_nodes = get_tree().get_nodes_in_group('active')
			if len(active_nodes) > 0:
				for active_node in active_nodes:
					active_node.active = false

	$EmptyLevel.done = done
	$EmptyLevel.passed = passed and has_next


func init(already_passed, exist_next_level):
	passed = already_passed
	has_next = exist_next_level


func back_to_menu():
	$EmptyLevel/LevelMenu.visible = true
	visible  = false
	emit_signal("back_to_menu", self, false)



func next_level():
	$EmptyLevel/LevelMenu.visible = true
	visible = false
	emit_signal("back_to_menu", self, true)


func close_level():
	queue_free()


func play_sound(sound):
	emit_signal("play_sound", sound)
