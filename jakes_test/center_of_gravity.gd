extends Node3D

@export var gravity = 20

# Change visuals to look like placement preview and disable gravity
@export var preview_mode = false

func _ready() -> void:
	if preview_mode:
		$Center.hide()
		$BlackHoleEffectBillboard.modulate.a = .5

func _physics_process(_delta: float) -> void:
	if preview_mode:
		return

	for body in get_tree().get_nodes_in_group("gravity_body"):
		var dist = body.global_position.distance_to(global_position)
		var force = gravity * (1. / float(pow(dist, 1)))
		if force > gravity:
			force = gravity

		var apply_gravity = force * body.global_position.direction_to(global_position)
		if body is RigidBody3D:
			body.apply_force(apply_gravity)
