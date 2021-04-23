/// @description Starts or stops the poisoned status condition on the player. This condition is set to cause
/// 1% damage; doubling each time it deals damage until the player is killed by it.
/// @param isPoisoned
function player_set_poisoned(_isPoisoned){
	// Reset the poison damage deal flag and the damage it deals if the player wasn't poisoned previously
	if (_isPoisoned && !isPoisoned){
		dealPoisonDamage = false;
		curPoisonDamage = 0.01;
	}
	isPoisoned = _isPoisoned;
	if (!isBleeding) {conditionTimer = 0;} // Reset condition timer if it isn't currently active for bleeding
	return argument_count;
}

/// @description Starts or stops the bleeding status condition on the player. This condition is set to deal
/// 5% of the player's maximum health every 2.5 seconds constantly, unlike poison's scaling damage.
/// @param isBleeding
function player_set_bleeding(_isBleeding){
	isBleeding = _isBleeding;
	if (!isPoisoned) {conditionTimer = 0;} // Reset condition timer if it isn't current active for poison
	return argument_count;
}

/// @description Adds a temporary effect onto the player, that can do any number of things at the start, end,
/// or during the effect's duration. The start and end functions don't need to be specified and can be ignored.
/// They are mostly used for things like temporary damage buffs/debuffs, hitpoint buffs/debuffs, sanity 
/// buffs/debuffs, and so on.
/// @param effectType
/// @param duration
/// @param startFunction
/// @param endFunction
function player_add_effect(_effectType, _duration, _startFunction, _endFunction){
	// If the effect exists, overwrite the duration only if it's greater than the previous duration or if
	// the duration being supplied is an indefinite duration value. If so, overwrite the current duration 
	// value with the new one.
	var _index = player_get_effect(_effectType); 
	if (_index != -1){ // Don't add the effect to the timers since there's a duplicate; just attempt to overwrite the duration
		if (effectTimers[| _index][0] == _effectType && (effectTimers[| _index][1] < _duration || effectTimers[| _index][1] == INDEFINITE_EFFECT)){
			effectTimers[| _index][1] = _duration;
		}
	} else{ // Pushes the effect with all of its details onto the array of current effects
		// Optionally, a script can be executed at the start of the effect, and also at the end. This allows 
		// for easily reversible effects like temporary max HP loss/max sanity loss, and vice versa.
		if (_startFunction != NO_SCRIPT && script_exists(_startFunction)){
			script_execute(_startFunction);
		}
		// The start function is placed in the effect timer index for when the data is saved and then loaded again.
		ds_list_add(effectTimers, [_effectType, _duration, _startFunction, _endFunction]);
	}
	return argument_count;
}

/// @description Attempts to remove a given effect from the list of active temporary effects. It will begin
/// by finding the index of the effect, and won't execute any code if it couldn't find said effect. If it
/// could find the effect, it will optionally perform the ending function associated to it when toggled by
/// the function call. Otherwise, it would just delete the effect from the list.
/// @param effectType
/// @param performEndFunction
function player_remove_effect(_effectType, _performEndFunction){
	var _index = player_get_effect(_effectType);
	if (_index != -1){ // If a valid index was found
		if (_performEndFunction && script_exists(effectTimers[| _index][3])){
			script_execute(effectTimers[| _index][3]); // Optionally perform the end function associated with the removed effect
		}
		ds_list_delete(effectTimers, _index);
	}
	return argument_count;
}

/// @description Searches through the list of effects to find the desired one. If the necessary effect can't
/// be found by the function, it will return a -1 as an "error" code. Otherwise, the effect's index within
/// the temporary effects list will be returned for further use.
/// @param effectType
function player_get_effect(_effectType){
	var _length = ds_list_size(effectTimers);
	for (var i = 0; i < _length; i++){
		if (effectTimers[| i][0] == _effectType) {return i;}
	}
	return -1;
}