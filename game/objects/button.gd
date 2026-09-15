extends Node3D

signal pushed
signal released

var pushed_signal_emitted = false
var released_signal_emitted = true

func _physics_process(_delta: float) -> void:
	if %PushPart.position.y <= .1:
		released_signal_emitted = false
		if not pushed_signal_emitted:
			pushed.emit()
			pushed_signal_emitted = true
	else:
		pushed_signal_emitted = false
		if not released_signal_emitted:
			released.emit()
			released_signal_emitted = true
