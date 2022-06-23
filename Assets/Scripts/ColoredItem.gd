extends Spatial


enum Colors {
	RED = 1,
	GREEN = 2,
	BLUE = 3,
	NO_COLOR = -1
}

export var item_name = ''
export(Colors) var color setget set_color
export var has_to_connect = false
export var fixed_color = false
export var fixed_rotation = false

var active = true
var color_list = {
	Colors.RED: {
		'color': Color.red,
		'inactive_color': Color.darkred,
		'group': 'red',
		'texture': 'res://Assets/Images/diamond_texture.png'
	},
	Colors.GREEN: {
		'color': Color.green,
		'inactive_color': Color.darkgreen,
		'group': 'green',
		'texture': 'res://Assets/Images/line_texture.png'

	},
	Colors.BLUE: {
		'color': Color.cyan,
		'inactive_color': Color.blue,
		'group': 'blue',
		'texture': 'res://Assets/Images/wave_texture.png'

	},
	Colors.NO_COLOR: {
		'color': Color.white
	}

}
var connected = false
var connections = []
onready var shape = $Shape


func _ready():
	update_color(null, color)


func check_connections():
	if len(connections) > 0:
		connected = true
	else:
		connected = false

	connections = []

	if shape:
		var new_albedo_color = color_list[color]['color']
		if !connected and 'inactive_color' in color_list[color].keys():
			new_albedo_color = color_list[color]['inactive_color']

		if 'texture' in color_list[color].keys():
			var texture = load(color_list[color]['texture'])
			get_material().set("albedo_texture", texture)
		else:
			get_material().set("albedo_texture", null)

		get_material().set("albedo_color", new_albedo_color)


func set_color(new_color):
	var old_color = color
	color = new_color

	update_color(old_color, new_color)
	

func update_color(old_color, new_color):
	if new_color != old_color:
		if old_color and 'group' in color_list[old_color].keys() and \
				is_in_group(color_list[old_color]['group']):
			remove_from_group(color_list[old_color]['group'])

		if new_color and 'group' in color_list[new_color].keys():
			add_to_group(color_list[new_color]['group'])


func get_material():
	return shape.material
