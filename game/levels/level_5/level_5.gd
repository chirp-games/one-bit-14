extends "res://game/levels/nologic_level.gd"


@export var hold_time := 3.

var progressing := false
var time := 0.
var last_second := -1

func succeeding() -> void:
	progressing = true

func failing() -> void:
	progressing = false
	time = 0
	last_second = -1
	%Failure.play()

func _process(delta: float) -> void:
	if progressing:
		time += delta
		
		if last_second != floor(time):
			last_second = floor(time)
			%Bleeper.pitch_scale = 1 + last_second * 0.25
			%Bleeper.play()
			
		if time > hold_time:
			await %Bleeper.finished
			level_complete.emit()
