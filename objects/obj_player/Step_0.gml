/// @description Gathering Input From User, Handle Current State and Non-State Code

#region HANDLING CURRENT STATE/MOVEMENT/OPENING INVENTORY

if (global.gameState == GameState.InGame && curState != NO_STATE){
	// Gets input from the currently active control method (Keyboard/Gamepads supported)
	if (!global.gamepadActive) {player_get_input_keyboard();}
	else {player_get_input_gamepad();}

	// Call the parent step event code, which handles the current state, health regen, and invulnerability time
	event_inherited();
	
	// Handling collision with cutscene triggers, which begins their respective cutscene
	var _trigger = instance_place(x, y, obj_cutscene_trigger);
	if (_trigger != noone){ // If the trigger variable is storing a valid ID
		instance_create_depth(0, 0, GLOBAL_DEPTH, obj_cutscene);
		with(global.singletonID[? CUTSCENE]){ // Copy over the data from the trigger and begin the cutscene
			ds_queue_copy(sceneData, _trigger.sceneData);
			parentTrigger = _trigger;
		}
		return; // Exit out of the step event early
	}
	
	// Handling collision with enemies and any projectiles they might use on the player
	if (!isHit){ // Only check these collisions when the player isn't invulnerable
		var _hostile, _damage, _isHit;
		_hostile = noone;
		_damage = 0;
		_isHit = false;
		
		// Colliding with an enemy object
		_hostile = instance_place(x, y, par_enemy);
		if (_hostile != noone){ // If the hostile contains a valid ID, set how much damage will be dealt
			_damage = _hostile.damage * global.gameplay.enemyDamageMod;
			_isHit = true;
		}
		
		// TODO -- Add enemy projectile collision check here
		
		// Lock the player in a stun for a set number of frames while shaking the screen at varying intensity
		// relative to the damage the player has been dealt. Also, freezes their current animation during stun.
		if (_isHit){
			set_camera_shake(_damage * 2.5, 10);
			set_entity_hit(_damage, 10);
		}
	}
	
	// Opening the player's item section of the inventory
	if (keyItems){
		var _controller = global.singletonID[? CONTROLLER];
		with(_controller) {showItems = !showItems;}
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