extends Node3D

signal pushed
signal released

var is_pushed: bool = false
var pushed_signal_emitted = false
var released_signal_emitted = true

var powered_material = load("res://assets/materials/wire_on.tres")
var off_material = load("res://assets/materials/wire_off.tres")

func laser_hit() -> void:
	is_pushed = true

func _physics_process(_delta: float) -> void:
	if is_pushed:
		released_signal_emitted = false
		if not pushed_signal_emitted:
			pushed.emit()
			for node in %change_material.get_children():
				node.set_surface_override_material(0, powered_material)
			pushed_signal_emitted = true
	else:
		pushed_signal_emitted = false
		if not released_signal_emitted:
			for node in %change_material.get_children():
				node.set_surface_override_material(0, off_material)
			released.emit()
			released_signal_emitted = true
	
	is_pushed = false
