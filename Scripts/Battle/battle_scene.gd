@tool
class_name BattleScene
extends Node2D

signal element_selected(element: Element)
signal target_added(target: BattleAvatar)

enum MenuState {CommandMenu, FightMenu}

@export var bg_frame: int = 0:
	set(frame):
		if set_bg_frame(frame):
			bg_frame = frame
@export var enemy_formation: int = 1:
	set(ef):
		if not ef in BattleGlobals.enemy_formations.keys():
			return
		enemy_formation = ef
		spawn_enemies_from_formation()
@onready var background: AnimatedSprite2D = $PlayerDisplayBox/VisMask/Background
@onready var background2: AnimatedSprite2D = $PlayerDisplayBox/VisMask/Background2
@onready var cursor: Sprite2D = $Cursor
@onready var command_menu: NinePatchRect = $CommandDisplayBox
@onready var fight_btn: TextButton = $CommandDisplayBox/VisMask/FightBtn
@onready var item_btn: TextButton = $CommandDisplayBox/VisMask/ItemBtn
@onready var run_btn: TextButton = $CommandDisplayBox/VisMask/RunBtn
@onready var fight_menu: NinePatchRect = $FightDisplayBox
@onready var default_move_btn: TextButton = $FightDisplayBox/VisMask/DefaultMoveBtn
@onready var move_btns: Array = []
@onready var textbox: Textbox = $Textbox
@onready var encounter_text: String = "Some enemies appeared!"
@onready var command_menu_elements: Array[TextButton] = [fight_btn, item_btn, run_btn]
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
	$PlayerDisplayBox/VisMask/BattleEnemy4,
]
var battle_avs: Array = []

var targetable_elements = []
var selected_element = null
@onready var current_turn: BattleAvatar
@onready var turn_order = battle_players + battle_enemies
@onready var menu_state: MenuState = MenuState.CommandMenu:
	set(s):
		menu_state = s
		update_menu_state()

func _ready():
	enemy_formation = BattleGlobals.enemy_formations.keys().pick_random()
	battle_avs = battle_enemies + battle_players
	for av in battle_avs:
		av.battle_scene = self
	reset_textbox()
	await textbox_print(encounter_text)
	menu_state = MenuState.CommandMenu
	fight_btn.selected.connect(_on_fight_btn_selected)
	next_turn()
	#if not Engine.is_editor_hint():
	#	while true:
	#		await get_tree().create_timer(0.5).timeout
	#		battle_avs.pick_random().show_hp_text(-5)
			
func _input(event):
	if (not event is InputEventMouseButton and not event.is_action_pressed("interact")) or not selected_element:
		return
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT or event.pressed == false:
			return
	selected_element.select()
	element_selected.emit(selected_element)
	
func despawn_all_enemies():
	for enemy in battle_enemies:
		enemy.enemy_id = BattleGlobals.Enemy.None
	reset_textbox()
	
func spawn_enemies_from_formation():
	despawn_all_enemies()
	var formation_data = BattleGlobals.enemy_formations.get(enemy_formation)
	for enemy in battle_enemies:
		var i = battle_enemies.find(enemy)
		if not i in range(0, len(formation_data)):
			continue
		enemy.enemy_id = formation_data[i].get(BattleGlobals.FormationData.Enemy, enemy.enemy_id)
		enemy.position = formation_data[i].get(BattleGlobals.FormationData.Position, enemy.position)
		encounter_text = formation_data[i].get(BattleGlobals.FormationData.EncounterText, encounter_text)
	
func next_turn(av = null):
	if not av is BattleAvatar:
		av = turn_order.pop_front()
	current_turn = av
	turn_order.push_back(av)
	if av is BattleEnemy and av.enemy_id == BattleGlobals.Enemy.None:
		next_turn()
	await textbox_print("%s's turn!" % current_turn.av_name)
	if av is BattlePlayer:
		menu_state = MenuState.CommandMenu
	else:
		do_enemy_turn()
		
func do_enemy_turn():
	var move: MoveBase = current_turn.moves.pick_random()
	var targets = []
	var possible_targets = battle_players.duplicate()
	for _i in range(move.target_count):
		var target = possible_targets.pick_random()
		targets.append(target)
		possible_targets.erase(target)
	move.use_attack(targets)
	await textbox_print("%s used %s!" % [current_turn.av_name, move.move_name])
	next_turn(turn_order.pop_front())
	
func reset_textbox():
	textbox.text = ""
	textbox.text_display.refresh_text()
	
func textbox_print(text: String):
	if Engine.is_editor_hint():
		return
	print(text)
	textbox.text += "%s%s" % ['\n' if len(textbox.text) > 0 else '', text]
	await textbox.text_display.char_queue_finished

func set_bg_frame(frame: int):
	if not background or not background2:
		return false
	if not frame in range(0, background.sprite_frames.get_frame_count("default")):
		return false 
	background.frame = frame
	background2.frame = frame
	return true
	
func update_menu_state():
	match menu_state:
		MenuState.CommandMenu:
			disable_menu(fight_menu)
			enable_menu(command_menu)
			set_targetable_elements(command_menu_elements)
		MenuState.FightMenu:
			disable_menu(command_menu)
			enable_menu(fight_menu)
			default_move_btn.hide()
			var current_pos = default_move_btn.position
			for btn in move_btns:
				btn.queue_free()
			move_btns = []
			for move in current_turn.moves:
				var move_btn: TextButton = default_move_btn.duplicate()
				fight_menu.get_child(0).add_child(move_btn)
				move_btn.show()
				move_btn.position = current_pos
				current_pos.y += 12
				move_btn.text = move.move_name
				move_btns.append(move_btn)
				move_btn.selected.connect(target_query.bind(move))
			set_targetable_elements(move_btns)
			
func disable_menu(menu: NinePatchRect):
	disable_targetable_elements(menu.find_children("*", "", true).filter(func(e): return e in targetable_elements))
	menu.hide()
	
func enable_menu(menu: NinePatchRect):
	menu.show()
	
func target_element(element):
	if not element.visible:
		return
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
	
func add_targetable_elements(elements):
	for element in elements:
		if not element is Element:
			continue
		targetable_elements.append(element)
		element.make_targetable(target_element, untarget_element)
		
func disable_targetable_elements(elements = targetable_elements):
	elements = elements.filter(func(e): return e in targetable_elements)
	if selected_element in elements:
		untarget_element(selected_element)
	for element in elements:
		element.make_untargetable(target_element, untarget_element)
		targetable_elements.erase(element)
		
func set_targetable_elements(elements):
	disable_targetable_elements()
	add_targetable_elements(elements)

func _on_fight_btn_selected():
	menu_state = MenuState.FightMenu
	
func target_query(move: MoveBase):
	var possible_targets = battle_enemies + battle_players
	match move.possible_targets:
		BattleGlobals.PossibleTargets.Players: possible_targets = battle_players
		BattleGlobals.PossibleTargets.Enemies: possible_targets = battle_enemies
		
	var targets = []
	var add_target: Callable = func add_target(e):
		if not e is BattleEnemy and not e is BattlePlayer:
			return
		targets.append(e)
		target_added.emit(e)
	while len(targets) < move.target_count:
		set_targetable_elements(possible_targets.filter(func(e): return not e in targets))
		element_selected.connect(add_target)
		await target_added
		if element_selected.is_connected(add_target):
			element_selected.disconnect(add_target)
	menu_state = MenuState.CommandMenu
	disable_targetable_elements()
	await textbox_print("%s used %s!" % [current_turn.av_name, move.move_name])
	move.use_attack(targets)
	await next_turn(turn_order.pop_front())
	
