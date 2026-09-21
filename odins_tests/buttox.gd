extends Node3D


signal pushed
signal released

var is_pushed: bool = false
var pushed_signal_emitted = false
var released_signal_emitted = true

func _physics_process(_delta: float) -> void:
	if $PushPart.position.distance_to($Box.position) < 0.506:
		released_signal_emitted = false
		if not pushed_signal_emitted:
			pushed.emit()
			$Box/ClickOn.play()
			pushed_signal_emitted = true
			is_pushed = true
	else:
		pushed_signal_emitted = false
		if not released_signal_emitted:
			released.emit()
			$Box/ClickOff.play()
			released_signal_emitted = true
			is_pushed = false
