@tool

extends Node3D

@export var powered = false:
	set(v):
		if all_nodes == null:
			return
		powered = v
		if powered:
			power_on()
		else:
			power_off()
	get():
		return powered

@export var type: Type

enum Type {
	Straight,
	Bend,
	Half,
}

var powered_material = load("res://assets/materials/wire_on.tres")
var off_material = load("res://assets/materials/wire_off.tres")

@onready var all_nodes = $Wires.get_children()

func hide_all():
	for node in all_nodes:
		node.hide()

func power_on():
	for node in all_nodes:
		node.set_surface_override_material(0, powered_material)

func power_off():
	for node in all_nodes:
		node.set_surface_override_material(0, off_material)

func _ready() -> void:
	if powered:
		power_on()
	else:
		power_off()

	if type == Type.Straight:
		hide_all()
		%straight.show()
	if type == Type.Bend:
		hide_all()
		%bend.show()
		%bend_2.show()
	if type == Type.Half:
		hide_all()
		%bend.show()
