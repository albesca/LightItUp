extends "res://Assets/Scripts/ColoredItem.gd"


func get_material_albedo_list():
	return [shape.get("material/1")]


func get_material_texture_list():
	return [shape.get("material/0")]
