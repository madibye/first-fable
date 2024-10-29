class_name MoveBase
extends Node

var move_id: BattleGlobals.Move = BattleGlobals.Move.BasicAttack:
	set(s):
		move_id = s
		refresh_data()
var move_name: String = "Attack"
var base_power: int = 5
var accuracy: int = -1
var charges: int = 5
var target_count: int = 1
var possible_targets: BattleGlobals.PossibleTargets = BattleGlobals.PossibleTargets.Avatars

func _ready():
	refresh_data()

func refresh_data():
	move_name = BattleGlobals.get_move_property(move_id, BattleGlobals.MoveProperty.Name)
	base_power = BattleGlobals.get_move_property(move_id, BattleGlobals.MoveProperty.BasePower)
	accuracy = BattleGlobals.get_move_property(move_id, BattleGlobals.MoveProperty.Accuracy)
	charges = BattleGlobals.get_move_property(move_id, BattleGlobals.MoveProperty.Charges)
	target_count = BattleGlobals.get_move_property(move_id, BattleGlobals.MoveProperty.TargetCount)
	possible_targets = BattleGlobals.get_move_property(move_id, BattleGlobals.MoveProperty.PossibleTargets)

func accuracy_check() -> bool:
	if accuracy == -1:
		return true
	return randf_range(0, 100) <= accuracy

func use_attack(targets: Array):
	for target in targets:
		var dmg = -base_power
		target.hp += dmg
		do_attack_anim(target, dmg)

func do_attack_anim(target: BattleAvatar, dmg: int):
	target.show_hp_text(dmg)
