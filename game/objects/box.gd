extends RigidBody3D

var last_velocity: Vector3 = Vector3.ZERO

func _physics_process(_delta: float) -> void:
	last_velocity = linear_velocity
	
func _on_body_entered(body: Node) -> void:
	var impact_velocity = (last_velocity - linear_velocity).length()
	print(impact_velocity)
	if !body.is_in_group("Player"):
		if impact_velocity >  10.0:	
			if !$BoxHitLoud.playing:
				$BoxHitLoud.play(0.04)
		elif impact_velocity >  3.0:	
			if !$BoxHit.playing:
				$BoxHit.play(0.04)
