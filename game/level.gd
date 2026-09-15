extends Node3D


func _on_button_1_pushed() -> void:
	print("pushed")

func _on_button_1_released() -> void:
	print("released")

func _physics_process(delta: float) -> void:
	if %Button1.is_pushed:
		%Platform.apply_central_force(Vector3(0, 1000, 0))
