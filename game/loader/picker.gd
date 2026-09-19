@tool
extends Control


const item = preload("res://game/loader/pick_item.tscn")

@export var bypass_unlocks = false

func quit() -> void:
	get_tree().quit()

func reset_unlocks() -> void:
	LevelManager.reset_unlocks()
	for button in %LevelList.get_children():
		button.check_locked()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	for level in LevelManager.levels:
		var button = item.instantiate()
		button.level = level
		button.bypass = bypass_unlocks
		%LevelList.add_child(button)
