@tool
class_name Actor
extends Node2D

@onready var overworld_level: OverworldLevel
var controls_locked: bool = false
var move_time: float = (4.0/15.0)
@export var direction: Vector2 = Vector2.DOWN

func interact(_player: OverworldPlayer):
	pass
