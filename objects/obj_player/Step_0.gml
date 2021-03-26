/// @description Gathering Input From User, Handle Current State and Other General Code

// Prevent function of the player's step event if the game isn't in its in game state, there is no state 
// set, or if the player had been destroyed on the previous frame.
if (global.gameState != GameState.InGame || curState == NO_STATE || isDestroyed){
	return;
}

#region HANDLING CURRENT STATE/MOVEMENT

// Gets input from the currently active control method (Keyboard/Gamepads supported)
if (!global.gamepadActive) {player_get_input_keyboard();}
else {player_get_input_gamepad();}

// Call the parent step event code, which handles everything else
event_inherited();

#endregion

#region HANDLING CONDITION/EFFECT TIMERS

// Handling the timer for the bleeding and poisoned statuses.
conditionTimer += global.deltaTime;
if (conditionTimer >= maxConditionTimer){
	conditionTimer -= maxConditionTimer;
	// Dealing bleeding damage every check (2.5 seconds of real-time)
	if (isBleeding){ // Damage is 5% of current maximum health constantly
		update_hitpoints(-maxHitpoints * 0.05);
	}
	// Dealing poison damage every other check (5 seconds of real-time)
	if (isPoisoned){ // Damage doubles every time; starts at 1% of current maximum health
		if (dealPoisonDamage){
			update_hitpoints(-maxHitpoints * curPoisonDamage);
			curPoisonDamage = min(curPoisonDamage * 2, 1); // Maxes out at damage at 100% of current maximum health
		}
		dealPoisonDamage = !dealPoisonDamage;
	}
}

// Handling the timer for depleting/regenerating the player's current sanity level
sanityTimer += global.deltaTime;
if (sanityTimer >= maxSanityTimer){
	sanityTimer -= maxSanityTimer;
	// The "base" sanity modifier can be either 1 or -1 depending on if the room is safe or not
	var _baseSanityMod = global.isRoomSafe ? SANITY_MOD_SAFE : SANITY_MOD_UNSAFE;
	curSanity = clamp(curSanity + _baseSanityMod + sanityModifier, 0, maxSanity);
}

// Handling the timers for each of the temporary immunity timers. If the value for the current immunity
// timer has a value of -1 it means a complete immunity from that status condition, damage resistance, or
// sanity depletion.
var _length = ds_list_size(effectTimers);
for (var i = 0; i < _length; i++){
	if (effectTimers[| i][1] != INDEFINITE_EFFECT){
		effectTimers[| i][1] -= global.deltaTime;
		if (effectTimers[| i][1] <= 0){ // Deletes the index from the array when the temporary effect is over.
			// Optionally, a function can be executed for the ending of a given effect
			if (effectTimers[| i][2] != NO_SCRIPT && script_exists(effectTimers[| i][2])){
				script_execute(effectTimers[| i][2]);
			}
			ds_list_delete(effectTimers, i);
			_length--; // Removes one from length to compensate for the deleted array index
		}
	}
}

#endregion

#region HANDLING MENU INPUTS FOR OPENING INVENTORY/PAUSE MENU

if (keyItems){
	global.controllerID.showItems = !global.controllerID.showItems;
}

#endregion