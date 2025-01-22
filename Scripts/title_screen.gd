class_name TitleScreen
extends Node2D

@onready var new_game_button: TextButton = $NGButton
@onready var continue_button: TextButton = $ContinueButton
@onready var element_manager

func _ready():
	element_manager = ElementManager.new()
	add_child(element_manager)
	element_manager.cursor.scale *= 0.25
	element_manager.set_targetable_elements([new_game_button, continue_button])
	new_game_button.selected.connect(_on_new_game_select)
	
func _on_new_game_select():
	SceneGlobals.master_scene.to_overworld_map()
