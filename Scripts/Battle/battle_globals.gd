@tool
extends Node

enum PlayerClass {Warrior, Rogue, BlackBelt, RedMage, BlackMage, WhiteMage}
enum Stat {HP, Attack, Defense, MAttack, MDefense, Speed}
enum Move {BasicAttack, Slap, MagicalShine, LightningStrike, IceStorm, FieryBlaze}
enum Enemy {None, TestEnemy, Jester, BLJster, Wolf, Hector, Knight}
enum EnemyProperty {Name, SpriteRegion, CursorPos, HpTextPos}
enum FormationData {Enemy, Position, EncounterText}
enum PossibleTargets {Avatars, Players, Enemies}
enum MoveProperty {Name, Class, BasePower, Accuracy, Charges, TargetCount, PossibleTargets}

var move_data: Dictionary = {
	Move.BasicAttack: {
		MoveProperty.Name: "Basic Attack",
		MoveProperty.Class: MoveBase,
		MoveProperty.BasePower: 5,
		MoveProperty.Accuracy: -1,
		MoveProperty.Charges: 5,
		MoveProperty.TargetCount: 1,
		MoveProperty.PossibleTargets: PossibleTargets.Enemies,
	},
	Move.Slap: {
		MoveProperty.Name: "Slap",
	},
	Move.MagicalShine: {
		MoveProperty.Name: "Magical Shine",
	},
	Move.LightningStrike: {
		MoveProperty.Name: "Lightning Strike",
	},
	Move.IceStorm: {
		MoveProperty.Name: "Ice Storm",
	},
	Move.FieryBlaze: {
		MoveProperty.Name: "Fiery Blaze",
	},
}

var enemy_data: Dictionary = {
	Enemy.TestEnemy: {
		EnemyProperty.Name: "Tester",
		EnemyProperty.SpriteRegion: Rect2(9, 23, 31, 31),
		EnemyProperty.CursorPos: Vector2(-6, 17),
		EnemyProperty.HpTextPos: Vector2(31, 10),
	},
	Enemy.Jester: {
		EnemyProperty.Name: "Jester",
		EnemyProperty.SpriteRegion: Rect2(9, 23, 31, 31),
	},
	Enemy.Knight: {
		EnemyProperty.Name: "Knight",
		EnemyProperty.SpriteRegion: Rect2(147, 13, 44, 46),
		EnemyProperty.CursorPos: Vector2(-6, 25),
		EnemyProperty.HpTextPos: Vector2(38, 12),
	},
	Enemy.BLJster: {
		EnemyProperty.Name: "BLJster",
		EnemyProperty.SpriteRegion: Rect2(43, 24, 31, 31),
	},
	Enemy.Wolf: {
		EnemyProperty.Name: "Wolf",
		EnemyProperty.SpriteRegion: Rect2(80, 28, 30, 29),
		EnemyProperty.CursorPos: Vector2(-5, 16),
		EnemyProperty.HpTextPos: Vector2(27, 11),
	},
	Enemy.Hector: {
		EnemyProperty.Name: "Hector",
		EnemyProperty.SpriteRegion: Rect2(116, 28, 30, 29),
		EnemyProperty.CursorPos: Vector2(-5, 16),
		EnemyProperty.HpTextPos: Vector2(27, 11),
	},
}

var enemy_formations = {
	1: [
		{FormationData.Enemy: Enemy.Jester, FormationData.Position: Vector2(18, 48)},
		{FormationData.Enemy: Enemy.Jester, FormationData.Position: Vector2(18, 80)},
		{FormationData.Enemy: Enemy.Knight, FormationData.Position: Vector2(54, 64),
		 FormationData.EncounterText: "Jesters and a Knight appeared!"},
	],
	2: [
		{FormationData.Enemy: Enemy.Wolf, FormationData.Position: Vector2(18, 48)},
		{FormationData.Enemy: Enemy.Wolf, FormationData.Position: Vector2(18, 80)},
		{FormationData.Enemy: Enemy.Jester, FormationData.Position: Vector2(54, 64),
		 FormationData.EncounterText: "Wolves and a Jester appeared!"},
	],
	3: [
		{FormationData.Enemy: Enemy.Jester, FormationData.Position: Vector2(18, 48)},
		{FormationData.Enemy: Enemy.Wolf, FormationData.Position: Vector2(18, 80)},
		{FormationData.Enemy: Enemy.BLJster, FormationData.Position: Vector2(51, 48)},
		{FormationData.Enemy: Enemy.Hector, FormationData.Position: Vector2(51, 80),
		 FormationData.EncounterText: "Wolves and Jesters appeared!"},
	],
}

func get_move_property(move: Move, property: MoveProperty):
	return move_data.get(move, move_data.get(Move.BasicAttack, {})).\
		get(property, move_data.get(Move.BasicAttack, {}).get(property, null))

func get_enemy_property(enemy: Enemy, property: EnemyProperty):
	return enemy_data.get(enemy, enemy_data.get(Enemy.TestEnemy, {})).\
		get(property, enemy_data.get(Enemy.TestEnemy, {}).get(property, null))
