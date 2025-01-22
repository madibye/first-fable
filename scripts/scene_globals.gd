@tool
extends Node

enum Map {TestOverworld}

const battle_scene_path: String = "res://Scenes/battle_scene.tscn"
const title_scene_path: String = "res://Scenes/title_screen.tscn"

const map_scenes: Dictionary = {
	Map.TestOverworld: "res://Scenes/test_overworld.tscn"
}

var master_scene: MasterScene
