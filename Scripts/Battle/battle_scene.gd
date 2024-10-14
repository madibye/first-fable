@tool
class_name BattleScene
extends Node2D

signal element_selected(element: Element)
signal target_added(target: BattleAvatar)

@export var bg_frame: int = 0:
	set(frame):
		if set_bg_frame(frame):
			bg_frame = frame
@onready var background: AnimatedSprite2D = $PlayerDisplayBox/VisMask/Background
@onready var background2: AnimatedSprite2D = $PlayerDisplayBox/VisMask/Background2
@onready var cursor: Sprite2D = $Cursor
@onready var command_box: NinePatchRect = $CommandDisplayBox
@onready var fight_btn: TextButton = $CommandDisplayBox/VisMask/FightBtn
@onready var item_btn: TextButton = $CommandDisplayBox/VisMask/ItemBtn
@onready var run_btn: TextButton = $CommandDisplayBox/VisMask/RunBtn
@onready var fight_box: NinePatchRect = $FightDisplayBox
@onready var default_move_btn: TextButton = $FightDisplayBox/VisMask/DefaultMoveBtn
@onready var command_box_elements: Array[TextButton] = [fight_btn, item_btn, run_btn]
@onready var battle_players: Array[BattlePlayer] = [
	$PlayerDisplayBox/VisMask/BattlePlayer,
	$PlayerDisplayBox/VisMask/BattlePlayer2,
	$PlayerDisplayBox/VisMask/BattlePlayer3,
	$PlayerDisplayBox/VisMask/BattlePlayer4
]
@onready var battle_enemies: Array[BattleEnemy] = [
	$PlayerDisplayBox/VisMask/BattleEnemy,
	$PlayerDisplayBox/VisMask/BattleEnemy2,
	$PlayerDisplayBox/VisMask/BattleEnemy3,
]
var battle_avs: Array = []

var targetable_elements = []
var selected_element = null
@onready var current_turn_av: BattleAvatar = $PlayerDisplayBox/VisMask/BattlePlayer

func _ready():
	fight_box.hide()
	command_box.show()
	set_targetable_elements([fight_btn, item_btn, run_btn])
	fight_btn.selected.connect(_on_fight_btn_selected)
	battle_avs = battle_enemies + battle_players
	for av in battle_avs:
		av.battle_scene = self
	#if not Engine.is_editor_hint():
	#	while true:
	#		await get_tree().create_timer(0.5).timeout
	#		battle_avs.pick_random().show_hp_text(randi_range(-1, -500))
			
func _input(event):
	if (not event is InputEventMouseButton and not event.is_action_pressed("interact")) or not selected_element:
		return
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT or event.pressed == false:
			return
	selected_element.select()
	element_selected.emit(selected_element)

func set_bg_frame(frame: int):
	if not background or not background2:
		return false
	if not frame in range(0, background.sprite_frames.get_frame_count("default")):
		return false 
	background.frame = frame
	background2.frame = frame
	return true
	
func target_element(element):
	if selected_element:
		untarget_element(selected_element)
	selected_element = element
	cursor.show()
	cursor.global_position = element.get_hitbox().cursor.global_position

func untarget_element(element):
	if selected_element != element:
		return
	cursor.hide()
	selected_element = null
		
func set_targetable_elements(elements):
	if selected_element:
		untarget_element(selected_element)
	for element in targetable_elements:
		element.make_untargetable(target_element, untarget_element)
	targetable_elements = []
	for element in elements:
		if not element is Element:
			continue
		targetable_elements.append(element)
		element.make_targetable(target_element, untarget_element)
		
func _on_fight_btn_selected():
	command_box.hide()
	fight_box.show()
	default_move_btn.hide()
	var current_pos = default_move_btn.position
	var move_btns = []
	for move in current_turn_av.moves:
		var move_btn: TextButton = default_move_btn.duplicate()
		fight_box.get_child(0).add_child(move_btn)
		move_btn.show()
		move_btn.position = current_pos
		current_pos.y += 12
		move_btn.text = move.move_name
		move_btns.append(move_btn)
		move_btn.selected.connect(target_query.bind(move))
	set_targetable_elements(move_btns)
	
func target_query(move: MoveBase):
	var targets = []
	var add_target: Callable = func add_target(e):
		if not e is BattleEnemy and not e is BattlePlayer:
			return
		targets.append(e)
		target_added.emit(e)
	while len(targets) < move.target_count:
		set_targetable_elements(battle_enemies.filter(func(e): return not e in targets))
		element_selected.connect(add_target)
		await target_added
		if element_selected.is_connected(add_target):
			element_selected.disconnect(add_target)
	move.use_attack(targets)
	fight_box.hide()
	command_box.show()
	set_targetable_elements(command_box_elements)
	
