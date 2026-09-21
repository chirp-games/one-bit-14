extends "res://game/levels/nologic_level.gd"


@export var pitch_curve: Curve
@export var time_limit := 10.
@export var max_pitch := 2.
@export var min_pitch := 1.

var ticks = 0


func timer_tick() -> void:
	if ticks >= time_limit:
		return
		
	ticks += 1
	if ticks == time_limit:
		$Fallout.collision_layer = 0 # Turns off collisions
		$Fallout.position = Vector3(0, 100, 0)
		$Fallout.hide()
		
	$Audio.pitch_scale = pitch_curve.sample(ticks / time_limit) * max_pitch + min_pitch
	$Audio.play()
