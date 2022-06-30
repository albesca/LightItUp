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
export var texture_shift_speed = 1.0
export var shifting_texture = false

var active = true
var color_list = {
	Colors.RED: {
		'color': Color.red,
		'inactive_color': Color.darkred,
		'group': 'red',
		'texture': 'res://Assets/Images/RedLight.png',
		'inactive_texture': 'res://Assets/Images/RedDark.png'
	},
	Colors.GREEN: {
		'color': Color.green,
		'inactive_color': Color.darkgreen,
		'group': 'green',
		'texture': 'res://Assets/Images/GreenLight.png',
		'inactive_texture': 'res://Assets/Images/GreenDark.png'
	},
	Colors.BLUE: {
		'color': Color.blue,
		'inactive_color': Color.darkblue,
		'group': 'blue',
		'texture': 'res://Assets/Images/BlueLight.png',
		'inactive_texture': 'res://Assets/Images/BlueDark.png'
	},
	Colors.NO_COLOR: {
		'color': Color.white,
		'inactive_color': Color.white
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
		var new_albedo_color = null
		if connected and 'color' in color_list[color].keys():
			new_albedo_color = color_list[color]['color']
		elif !connected and 'inactive_color' in color_list[color].keys():
			new_albedo_color = color_list[color]['inactive_color']

		if new_albedo_color != null:
			for material in get_material_albedo_list():
				material.set("albedo_color", new_albedo_color)

		var texture = null
		if connected and 'texture' in color_list[color].keys():
			texture = load(color_list[color]['texture'])
		elif !connected and 'inactive_texture' in color_list[color].keys():
			texture = load(color_list[color]['inactive_texture'])

		if shifting_texture:
			for material in get_material_texture_list():
				var texture_direction = Vector3.ZERO
				var emission = 0
				if connected:
					texture_direction = Vector3.UP * texture_shift_speed
					emission = 1

				material.set_shader_param("texture_direction", \
						texture_direction)
				material.set_shader_param("albedo_texture", texture)
				material.set_shader_param("emission_color", new_albedo_color)
				material.set_shader_param("emission", emission)
		else:
			for material in get_material_texture_list():
				material.set("albedo_texture", texture)



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


func get_material_albedo_list():
	return [shape.material]

func get_material_texture_list():
	return [shape.material]
