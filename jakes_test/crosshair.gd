extends Control

func _ready() -> void:
	%KickIndicator.hide()
	%KickPower.hide()

func show_kick_indicator():
	%KickIndicator.show()
	%KickPower.show()

func hide_kick_indicator():
	%KickIndicator.hide()
	%KickPower.hide()

func set_kick_power(power):
	%KickPower.value = power
	
