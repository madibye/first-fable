class_name MasterScene
extends Node2D

var active_scene: Node

func _ready():
	SceneGlobals.master_scene = self
	to_title_screen()

func change_scene(scene: Node, fade_time: float = 0.0):
	if active_scene:
		if fade_time >= 0.0 and active_scene.get("modulate") != null:
			var fade_out_tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			fade_out_tween.tween_property(active_scene, "modulate:a", 0, fade_time)
			await fade_out_tween.finished
		active_scene.queue_free()
	add_child(scene)
	active_scene = scene
	if fade_time >= 0.0 and active_scene.get("modulate") != null:
		var fade_in_tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		active_scene.modulate.a = 0
		fade_in_tween.tween_property(active_scene, "modulate:a", 1, fade_time)
		await fade_in_tween.finished
	
func to_title_screen() -> void:
	var scene = preload(SceneGlobals.title_scene_path).instantiate() as TitleScreen
	change_scene(scene)
	
func to_overworld_map() -> void:
	var scene = preload(SceneGlobals.map_scenes[SceneGlobals.Map.TestOverworld]).instantiate() as OverworldLevel
	change_scene(scene)

func to_battle_scene(formation: int) -> void:
	var scene = preload(SceneGlobals.battle_scene_path).instantiate() as BattleScene
	if formation not in BattleGlobals.enemy_formations.keys():
		formation = BattleGlobals.enemy_formations.keys().pick_random()
	scene.enemy_formation = formation
	change_scene(scene)
	
