extends Node3D


@export var gravity = 20

func _physics_process(_delta: float) -> void:
	for body in get_tree().get_nodes_in_group("gravity_body"):
		var dist = body.global_position.distance_to(global_position)

		var apply_gravity = gravity * (1. / float(pow(dist, 2.))) * body.global_position.direction_to(global_position)
		
		if body is RigidBody3D:
			body.apply_force(apply_gravity)
		
		if body.is_in_group("player"):
			if body.global_position.distance_to(global_position) < 1:
				print("You died")
				get_tree().quit()
