class_name MoveBase
extends Node

var move_name: String = "Attack"
var base_power: int = 5
var accuracy: int = -1
var charges: int = 5
var target_count: int = 1

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
