@tool
extends Node

enum PartyData {PlayerClass, AvName, Moves}

var default_player_info = {
	PartyData.PlayerClass: BattleGlobals.PlayerClass.BlackMage,
	PartyData.AvName: "Madi",
	PartyData.Moves: [BattleGlobals.Move.BasicAttack],
}

var party_data = {
	1: {
		PartyData.PlayerClass: BattleGlobals.PlayerClass.BlackMage,
		PartyData.AvName: "Madi",
		PartyData.Moves: [
			BattleGlobals.Move.MagicalShine, BattleGlobals.Move.LightningStrike, 
			BattleGlobals.Move.IceStorm, BattleGlobals.Move.FieryBlaze],
	}, 2: {
		PartyData.PlayerClass: BattleGlobals.PlayerClass.Rogue,
		PartyData.AvName: "Jay",
	}, 3: {
		PartyData.PlayerClass: BattleGlobals.PlayerClass.WhiteMage,
		PartyData.AvName: "Liko",
	}, 4: {
		PartyData.PlayerClass: BattleGlobals.PlayerClass.RedMage,
		PartyData.AvName: "Gyro",
	},
}

func get_player_property(slot: int, property: PartyData):
	return party_data.get(slot, default_player_info).get(property, default_player_info.get(property, null))
	
