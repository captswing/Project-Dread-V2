/// @description Gathering Input From User, Handle Current State and Other General Code

#region HANDLING CURRENT STATE/MOVEMENT/OPENING INVENTORY

if (global.gameState == GameState.InGame && curState != NO_STATE){
	// Gets input from the currently active control method (Keyboard/Gamepads supported)
	if (!global.gamepadActive) {player_get_input_keyboard();}
	else {player_get_input_gamepad();}

	// Call the parent step event code, which handles the current state and health regen
	event_inherited();
	
	// Handling collision with cutscene triggers, which begins the cutscene
	var _trigger = instance_place(x, y, obj_cutscene_trigger);
	if (_trigger != noone){ // If the trigger is storing a valid ID
		instance_create_depth(0, 0, GLOBAL_DEPTH, obj_cutscene);
		ds_queue_copy(global.cutsceneID.sceneData, _trigger.sceneData);
		return; // Exit out of the step event early
	}
	
	// Opening the player's item section of the inventory
	if (keyItems){
		global.controllerID.showItems = !global.controllerID.showItems;
	}
}

#endregion

#region HANDLING CONDITION/EFFECT TIMERS

// If the entire game is in a cutscene or paused, don't allow timers to be incremented
if (global.gameState >= GameState.Cutscene){
	return;
}

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
	// Only deplete the sanity if it is toggled on in the gameplay difficulty settings
	if (global.gameplay.playerLosesSanity){
		// The "base" sanity modifier can be either 1 or -1 depending on if the room is safe or not
		var _baseSanityMod = global.isRoomSafe ? SANITY_MOD_SAFE : SANITY_MOD_UNSAFE;
		curSanity = clamp(curSanity + _baseSanityMod + sanityModifier, 0, maxSanity);
	}
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