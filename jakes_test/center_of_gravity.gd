extends Node3D

@export var gravity = 20

# Change visuals to look like placement preview and disable gravity
@export var preview_mode = false

func _ready() -> void:
	if preview_mode:
		$Center.hide()
		$BlackHoleEffectBillboard.modulate.a = .5
		$AudioStreamPlayer3D.queue_free()
		remove_from_group("curves_light")
	else:
		set_notify_transform(true)

func mute() -> void:
	if preview_mode:
		return
	get_tree().create_tween().tween_property($AudioStreamPlayer3D, "volume_db", -80, 0.1)

func unmute() -> void:
	if preview_mode:
		return
	get_tree().create_tween().tween_property($AudioStreamPlayer3D, "volume_db", 0, 0.1)

func _physics_process(_delta: float) -> void:
	if preview_mode:
		return

	for body in get_tree().get_nodes_in_group("gravity_body"):
		var dist = body.global_position.distance_to(global_position)
		var force = gravity * (1. / float(pow(dist, 2)))
		if force > gravity:
			force = gravity

		var apply_gravity = force * body.global_position.direction_to(global_position)
		if body is RigidBody3D:
			body.apply_force(apply_gravity)
