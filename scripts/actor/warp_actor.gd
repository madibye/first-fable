class_name WarpActor
extends Actor

@export var warp_pos: Vector2

func _ready():
	can_walk_over = true

func walk_over(player: OverworldPlayer):
	pass
