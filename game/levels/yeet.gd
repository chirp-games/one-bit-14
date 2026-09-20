extends "res://game/levels/nologic_level.gd"

signal three

var b2 = false
var b3 = false
var b4 = false

func _physics_process(delta: float) -> void:
	%Launcher.speed = max(0.5, %Launcher.progress_ratio * 10)

func button2():
	b2 = true
	check()

func button3():
	b3 = true
	check()

func button4():
	b4 = true
	check()

func check():
	if b2 and b3 and b4:
		three.emit()
