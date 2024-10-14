class_name OverworldLevel
extends TileMapLayer

@onready var ui_layer: CanvasLayer = $UILayer
var actor_positions: Dictionary = {}

func _ready():
	for actor in get_child_actors():
		actor.overworld_level = self

func _process(_delta):
	for actor in get_child_actors():
		actor_positions[actor] = local_to_map(actor.position)

func get_child_actors():
	return get_children().filter(func(a): return a is Actor)
