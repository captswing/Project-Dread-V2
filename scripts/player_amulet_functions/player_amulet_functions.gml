/// @description Checks both amulet slots to see if the player current has the desired amulet equipped. It will
/// always return false if both slot variables contain no data (-1) and it will return either true or false
/// depending on if the amulet contained in the slot is the correct one.
/// @param name
function player_is_amulet_equipped(_name){
	var _slot1, _slot2; // Store in local variables for easy readability
	_slot1 = equipSlot[EquipSlot.AmuletOne];
	_slot2 = equipSlot[EquipSlot.AmuletTwo];
	
	if (_slot1 != -1 && _slot2 == -1){ // Only the first slot has an amulet equipped
		return (global.invItem[_slot1][0] == _name);
	} else if (_slot2 != -1){ // Both amulet slots are occupied, check both for the desired amulet
		return (global.invItem[_slot1][0] == _name || global.invItem[_slot2][0] == _name);
	}
	
	// No amulets are equipped; instantly return false
	return false;
}

/// @description Handles equipping and unequipping the fortified amulet, which provides a 50% bonus to damage
/// resistance when equipped at no cost of movement speed.
function player_amulet_fortified(){
	var _damageResist = 0.5; // Store the damage resistance in a single variable for easy adjustment
	if (player_is_amulet_equipped(FORTIFIED_AMULET)){ // Unequipping the amulet
		damageResistance += _damageResist;
	} else{ // Equipping the amulet
		damageResistance -= _damageResist;
	}
}

/// @description Handles equipping and unequipping the immunity amulet, which provides an indefinite immunity
/// to the poison status condition. Equipping it doesn't actually cure the poison status condition, however;
/// that still needs to be done with consumables that cure the condition.
function player_amulet_immunity(){
	if (player_is_amulet_equipped(IMMUNITY_AMULET)){ // Unequipping the amulet
		player_remove_effect(Effect.PoisonImmunity, false);
	} else{ // Equipping the amulet
		player_add_effect(Effect.PoisonImmunity, INDEFINITE_EFFECT, NO_SCRIPT, NO_SCRIPT);
	}
}

/// @description Handles equipping and unequipping the toughness amulet, which provides an indefinite immunity
/// to the bleeding status condition. Equipping it doesn't cure the bleeding status -- much like the immunity
/// amulet above.
function player_amulet_toughness(){
	if (player_is_amulet_equipped(TOUGHNESS_AMULET)){ // Unequipping the amulet
		player_remove_effect(Effect.BleedImmunity, false);
	} else{ // Equipping the amulet
		player_add_effect(Effect.BleedImmunity, INDEFINITE_EFFECT, NO_SCRIPT, NO_SCRIPT);
	}
}

/// @description Handles equipping and unequipping the healing amulet, which gives the player health regeneration
/// over time. The actual amount is 5% of the player's max hitpoints every 10 seconds.
function player_amulet_healing(){
	var _regenAmount, _regenSpeed; // Store the regeneration's stats into two local variables for easy adjustment
	_regenAmount = maxHitpoints * 0.05;
	_regenSpeed = 10; // 1 = 1 second of real-time, unlike most timers
	if (player_is_amulet_equipped(HEALING_AMULET)){ // Unequipping the amulet
		entity_update_regeneration_ratio(-_regenAmount, _regenSpeed);
	} else{ // Equipping the amulet
		entity_update_regeneration_ratio(_regenAmount, _regenSpeed);
	}
}