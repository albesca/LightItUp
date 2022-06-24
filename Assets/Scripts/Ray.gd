extends "res://Assets/Scripts/ColoredItem.gd"


export var rotation_speed = 1


func _process(delta):
	if len(connections) > 0:
		connected = true
	else:
		connected = false

	connections = []

	if shape:
		var new_albedo_color = color_list[color]['color']
		if !connected and 'inactive_color' in color_list[color].keys():
			new_albedo_color = color_list[color]['inactive_color']

		for material in get_material_albedo_list():
			material.set("albedo_color", new_albedo_color)

	$Shape.rotate_y(rotation_speed * delta)
	if connected:
		$Shape.material.set('emission_enabled', true)
		$Shape.material.set('emission', color_list[color]['color'])
	else:
		$Shape.material.set('emission_enabled', false)
