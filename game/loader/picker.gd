@tool
extends Control


const item = preload("res://game/loader/pick_item.tscn")

@export var bypass_unlocks = false

func _ready() -> void:
	for level in LevelManager.levels:
		var button = item.instantiate()
		button.level = level
		button.bypass = bypass_unlocks
		%LevelList.add_child(button)
