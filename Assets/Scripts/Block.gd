extends "res://Assets/Scripts/ColoredItem.gd"


signal play_sound(sound)

export var rotated = false
export var rotation_speed = 10
export var min_scale = 0.8
export var max_scale = 1.25
export var pulse_speed = 0.5

var ray_target = Vector3.INF
var pulse = false
var positive_pulse = true
var base_shape_scale
var base_cross_scale
var current_scale = 1


func _ready():
	base_cross_scale = $Cross.scale
	base_shape_scale = $Shape.scale


func _process(delta):
	if pulse and active:
		if positive_pulse:
			current_scale += delta * pulse_speed
			if current_scale > max_scale:
				current_scale = max_scale
				positive_pulse = false
		else:
			current_scale -= delta * pulse_speed
			if current_scale < min_scale:
				current_scale = min_scale
				positive_pulse = true

		if !fixed_color:
			$Shape.scale = Vector3(base_shape_scale.x * current_scale, \
					base_shape_scale.y * current_scale, \
					base_shape_scale.z * current_scale)

		if !fixed_rotation:
			$Cross.scale = Vector3(base_cross_scale.x * current_scale, \
					base_cross_scale.y, base_cross_scale.z * current_scale)

	else:
		$Shape.scale = base_shape_scale
		$Cross.scale = base_cross_scale
		positive_pulse = true
	
	$Ray.set('color', color)
	if color != Colors.NO_COLOR:
		if rotated:
			if !$RayCastNorthEast.enabled:
				$RayCastNorthEast.set_deferred('enabled', true)
			if !$RayCastNorthWest.enabled:
				$RayCastNorthWest.set_deferred('enabled', true)
			if !$RayCastSouthEast.enabled:
				$RayCastSouthEast.set_deferred('enabled', true)
			if !$RayCastSouthWest.enabled:
				$RayCastSouthWest.set_deferred('enabled', true)
			if $RayCastEast.enabled:
				$RayCastEast.set_deferred('enabled', false)
			if $RayCastWest.enabled:
				$RayCastWest.set_deferred('enabled', false)
			if $RayCastNorth.enabled:
				$RayCastNorth.set_deferred('enabled', false)
			if $RayCastSouth.enabled:
				$RayCastSouth.set_deferred('enabled', false)
		else:
			if !$RayCastEast.enabled:
				$RayCastEast.set_deferred('enabled', true)
			if !$RayCastWest.enabled:
				$RayCastWest.set_deferred('enabled', true)
			if !$RayCastNorth.enabled:
				$RayCastNorth.set_deferred('enabled', true)
			if !$RayCastSouth.enabled:
				$RayCastSouth.set_deferred('enabled', true)
			if $RayCastNorthEast.enabled:
				$RayCastNorthEast.set_deferred('enabled', false)
			if $RayCastNorthWest.enabled:
				$RayCastNorthWest.set_deferred('enabled', false)
			if $RayCastSouthEast.enabled:
				$RayCastSouthEast.set_deferred('enabled', false)
			if $RayCastSouthWest.enabled:
				$RayCastSouthWest.set_deferred('enabled', false)
	else:
		if $RayCastEast.enabled:
			$RayCastEast.set_deferred('enabled', false)
		if $RayCastWest.enabled:
			$RayCastWest.set_deferred('enabled', false)
		if $RayCastNorth.enabled:
			$RayCastNorth.set_deferred('enabled', false)
		if $RayCastSouth.enabled:
			$RayCastSouth.set_deferred('enabled', false)
		if $RayCastNorthEast.enabled:
			$RayCastNorthEast.set_deferred('enabled', false)
		if $RayCastNorthWest.enabled:
			$RayCastNorthWest.set_deferred('enabled', false)
		if $RayCastSouthEast.enabled:
			$RayCastSouthEast.set_deferred('enabled', false)
		if $RayCastSouthWest.enabled:
			$RayCastSouthWest.set_deferred('enabled', false)

	var new_ray_target = get_ray_target()
	if connected:
		$Shape.rotate_x(rotation_speed * delta)
		$Shape.rotate_y(rotation_speed * delta * 0.5)
		$Shape.rotate_z(rotation_speed * delta * 2.0)

	if new_ray_target != ray_target:
		$Ray.rotation = Vector3.ZERO
		ray_target = new_ray_target
		if ray_target != Vector3.INF:
			if !$Ray.visible:
				$Ray.visible = true

			var origin = $Ray.global_transform.origin
			var axis_y = $Ray.global_transform.basis.y
			$Ray.scale.y = origin.distance_to(ray_target)
			var axis = axis_y.cross( \
					origin.direction_to(ray_target)).normalized()
			axis.rotated(global_transform.basis.y, rotation.y)
			var angle = axis_y.angle_to(ray_target - origin)
			$Ray.rotate(axis, angle)

		else:
			if $Ray.visible:
				$Ray.visible = false
				$Ray.scale.y = 1


func checkCollider(raycast, ray_targets, colliders):
	if raycast.enabled and raycast.get_collider():
		var collider = raycast.get_collider()
		var group = null
		if 'group' in color_list[color].keys():
			group = color_list[color]['group']

		if group and collider.is_in_group(group) and \
				!collider.is_in_group('ray'):
			var new_ray_target = raycast.get_collision_point()
			colliders[new_ray_target] = collider
			ray_targets.append(new_ray_target)


func get_ray_target():
	var new_ray_target = Vector3.INF
	var ray_targets = []
	var colliders = {}
	checkCollider($RayCastEast, ray_targets, colliders)
	checkCollider($RayCastWest, ray_targets, colliders)
	checkCollider($RayCastNorth, ray_targets, colliders)
	checkCollider($RayCastSouth, ray_targets, colliders)
	checkCollider($RayCastNorthEast, ray_targets, colliders)
	checkCollider($RayCastNorthWest, ray_targets, colliders)
	checkCollider($RayCastSouthEast, ray_targets, colliders)
	checkCollider($RayCastSouthWest, ray_targets, colliders)
	
	if len(ray_targets) == 1:
		new_ray_target = ray_targets[0]
	elif len(ray_targets) > 1:
		for target in ray_targets:
			if new_ray_target == Vector3.INF or \
					global_transform.origin.distance_to(target) < \
					global_transform.origin.distance_to(new_ray_target):
				new_ray_target = target

	if new_ray_target in colliders.keys():
		var collider = colliders[new_ray_target]
		collider.connections.append(self)
		connections.append(collider)
		$Ray.connections.append(collider)

	return new_ray_target


func change_color_or_rotation(_camera, event, _click_position, _click_normal, \
		_shape_idx):
	if active:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT \
				and event.pressed and !fixed_color:
			emit_signal("play_sound", 'press')
			var new_color = color + 1
			if !new_color in color_list.keys():
				if new_color > Colors.BLUE:
					new_color = Colors.NO_COLOR
				else:
					new_color = Colors.RED
					
			update_color(color, new_color)
			color = new_color
		elif event is InputEventMouseButton and event.button_index == \
				 BUTTON_RIGHT and event.pressed and !fixed_rotation:
			emit_signal("play_sound", 'press2')
			rotated = !rotated
			$Cross.rotate_y(PI / 4.0)


func get_material_albedo_list():
	return [shape.get("material/1")]


func get_material_texture_list():
	return [shape.get("material/0")]


func mouse_entered():
	if (!fixed_color or !fixed_rotation) and active:
		emit_signal("play_sound", 'enter')
		pulse = true


func mouse_exited():
	if (!fixed_color or !fixed_rotation) and active:
		emit_signal("play_sound", 'exit')

	pulse = false
