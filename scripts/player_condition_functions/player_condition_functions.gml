/// @description Sets the player's bleeding status condition. Optionally, the condition timer will be reset
/// if the player isn't currently poisoned, since both conditions are tied to the same timer variable.
/// @param isBleeding
function set_bleeding(_isBleeding){
	isBleeding = _isBleeding;
	// Resets the condition timer if the player isn't currently poisoned
	conditionTimer = !isPoisoned ? 0 : conditionTimer;
}

/// @description Sets the player's poisoned status condition. It also resets the poison damage if the player
/// wasn't poisoned beforehand. Optionally, the condition timer will be reset if the player isn't currently
/// bleeding, since both of those conditions are tied to the same timer.
/// @param isPoisoned
function set_poisoned(_isPoisoned){
	// If the player wasn't currently poisoned; reset both variables that handle damaging with poison
	if (!isPoisoned){
		dealPoisonDamage = false;
		curPoisonDamage = 0.01;
	}
	isPoisoned = _isPoisoned;
	// Resets the condition timer if the player isn't current bleeding
	conditionTimer = !isBleeding ? 0 : conditionTimer;
}

/// @description Adjusts the sanity's current modifier based on the value that was provided. In order to
/// remove this modifier from the total, it'll have to be subtracted again at another point in time.
/// @param modifier
function update_sanity_modifier(_modifier){
	sanityModifier += _modifier;
}

/// @description Resets the player's current sanity modifier back to 0.
function reset_sanity_modifier(){
	sanityModifier = 0;
}

/// @description Sets the sanity to a completely new value that can range between 0 and the maximum sanity
/// value, which is 100. Optionally, the sanity timer can be reset by this function as well.
/// @param newValue
/// @param resetTimer
function set_sanity(_newValue, _resetTimer){
	curSanity = clamp(_newValue, 0, maxSanity);
	// Resets the sanity check timer if the function calls for it
	sanityTimer = _resetTimer ? 0 : sanityTimer;
}

/// @description
/// @param modifier
/// @param resetTimer
function update_sanity(_modifier, _resetTimer){
	curSanity = clamp(curSanity + _modifier, 0, maxSanity);
	// Resets the sanity check timer if the function calls for it
	sanityTimer = _resetTimer ? 0 : sanityTimer;
}

/// @description Updates the player's current maximum sanity value with a specified modifier. This means that
/// the player's sanity can range from more then 0 to 100 or less than that range. It all depends on certain
/// effects/conditions that are effecting the player at the moment.
/// @param modifier
function update_max_sanity(_modifier){
	maxSanity = max(1, maxSanity + _modifier);
	if (curSanity > maxSanity){
		curSanity = maxSanity;
	}
}

/// @description Adds a new effect to the array of current active effects. These can be both positive or
/// negative. For example, temporary damage immunity, poison, hallucination periods, and bleeding resistance 
/// are all tied to these timers. Optionally, functions can be specified that execute specific code pertaining
/// to the acquired effect(s).
/// @param effectType
/// @param duration
/// @param endFunction
/// @param startFunction
function add_new_effect(_effectType, _duration, _endFunction, _startFunction){
	if (is_effect_active(_effectType)){
		return; // Prevents two identical effect timers from being active at once
	}
	// Optionally, a script can be executed at the start of the effect, and also at the end. This allows 
	// for easily reversible effects like temporary max HP loss/max sanity loss, and vice versa.
	if (_startFunction != NO_SCRIPT && script_exists(_startFunction)){
		script_execute(_startFunction);
	}
	// Pushes the effect with all of its details onto the array of current effects
	ds_list_add(effectTimers, [_effectType, _duration, _endFunction]);
}

/// @description Linearly searches through the array of currently active effect timers for the required one.
/// If it's found, the function will return true, and will return false if the effect isn't currently active.
/// @param effectType
function is_effect_active(_effectType){
	var _length = ds_list_size(effectTimers);
	for (var i = 0; i < _length; i++){
		if (effectTimers[| i][0] == _effectType){
			return true;
		}
	}
	return false;
}