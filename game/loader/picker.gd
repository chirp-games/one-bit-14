@tool
extends Control


const item = preload("res://game/loader/pick_item.tscn")

func _ready() -> void:
	for level in LevelManager.levels:
		var button = item.instantiate()
		button.level = level
		%LevelList.add_child(button)
