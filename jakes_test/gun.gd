extends Node3D

func show_recharge_status(charging: bool):
	var material: StandardMaterial3D = $Gun.get_surface_override_material(1)
	if charging:
		material.emission_enabled = false
		material.albedo_color = Color.BLACK
	else:
		material.emission_enabled = true
		material.albedo_color = Color.WHITE
