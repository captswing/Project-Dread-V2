/// @description The player's default state. In a basic summary, the player is able to walk around at their
/// current full speed; with an optional boost to that speed if they are running. On top of that, the player
/// can swap out the ammunition on their currently equipped gun, aim/ready their weapon, and interact with
/// nearby objects.
function player_state_default(){
	// Toggling the equipped flashlight on and off
	if (keyFlashlight && equipSlot[EquipSlot.Flashlight] != NO_ITEM){
		isLightActive = !isLightActive;
		if (isLightActive){ // Turning the flashlight back on with the stored settings
			light_update_settings(ambLight, lightSize, lightSize, lightStrength, lightColor);
		} else{ // Turning the flashlight back into the dim ambient light
			light_update_settings(ambLight, 15, 15, 0.01, c_ltgray);
		}
		// Play the flashlight toggle sound effect
		play_sound_effect(snd_flashlight, get_audio_group_volume(Settings.Sounds), true);
		// Finally, update collectability based on light sources
		with(par_interactable) {checkForLights = true;}
	}
	
	// Interacting with certain objects in the world
	if (keyInteract){
		var _offset = [x + lengthdir_x(8, direction), y + lengthdir_y(8, direction) - 4];
		with(instance_nearest(_offset[X], _offset[Y], par_interactable)){
			// Ignores interaction if the object cannot be currently seen by the player. If it can be seen,
			// the interaction point will be checked against the maximum interaction distance. If the value
			// is lower than the max distance, an interaction will occur. If draw sprite is false, the
			// interactible is deactivated and shouldn't be processed for interaction.
			if (drawSprite && canInteract && point_distance(interactCenter[X], interactCenter[Y], _offset[X], _offset[Y]) <= interactRadius){
				if (interactScript != NO_SCRIPT) {script_execute(interactScript);}
				return; // Exit out of the script early
			}
		}
	}
	
	// Controls that relate to the player's currently equipped weapon
	if (equipSlot[EquipSlot.Weapon] != -1){
		var _slot, _name; // Store the slot and the wepaon's name for easy reference
		_slot = equipSlot[EquipSlot.Weapon];
		_name = global.invItem[_slot][0];
		
		// Readying the player's currently equipped weapon
		if (keyReadyWeapon){
			set_cur_state(player_state_weapon_ready);
			return; // Exit the current state early
		}
	
		// Controls that only apply to weapons that consume ammo when used
		if (global.itemData[? ITEM_LIST][? _name][? ITEM_TYPE] != WEAPON_INF){
			// Reloading the player's currently equipped weapon
			if (keyReload && global.invItem[_slot][1] < global.itemData[? ITEM_LIST][? _name][? MAX_STACK]){
				// Only reload if the invenotry contains spare ammunition
				if (inventory_count(ammoTypes[| curAmmoType[? _name]]) > 0) {set_cur_state(player_state_weapon_reload);}
				return; // Exit the current state early
			}
			
			// Swapping the player's currently equipped ammunition
			if (keyAmmoSwap && ds_list_size(ammoTypes) > 1){
				if (player_swap_current_ammo(curAmmoType[? _name])) {set_cur_state(player_state_weapon_reload);}
				return; // Exit the current state early
			}
		}
	}
	
	// Making the player run; the lower their health, the slower they'll move while they're running.
	if (keyRun) {inputMagnitude *= 1.1 + ((hitpoints / maxHitpoints) * 0.25);}
	
	// Set velocity based on current player input; remove any existing fractional values in both variables
	hspd = lengthdir_x(inputMagnitude * maxHspd, inputDirection);
	vspd = lengthdir_y(inputMagnitude * maxVspd, inputDirection);
	remove_movement_fractions();
	
	// Finally, handle collision with the world's colliders
	entity_world_collision(false);
	
	// Setting the correct sprite for the entity; reflecting what the player is doing at that moment
	if (inputMagnitude != 0){  // The player is moving; update the direction based on input
		entity_set_sprite(walkSprite, 4);
		// TODO -- Add change to running sprite here
		direction = inputDirection;
	} else{ // The player is standing still; don't update direction based on input
		entity_set_sprite(standSprite, 4);
	}
}

/// @description The player's state whenever they have their weapon ready for use. Once in this state,
/// they must hold the "ready weapon" key the entire time, and can press the "use weapon" key to use
/// said weapon. HOWEVER, the weapon won't be used if the player has no ammo for the weapon. (This
/// doesn't apply to melee weapons -- excluding the chainsaw)
function player_state_weapon_ready(){
	// The player released the ready weapon key; return to their previous state
	if (!keyReadyWeapon){
		set_cur_state(player_state_default);
		return; // Exit out of the state early
	}
	
	// Using the player's current weapon
	if (keyUseWeapon){
		var _slot, _useAmmo;
		_slot = equipSlot[EquipSlot.Weapon];
		_useAmmo = (global.itemData[? ITEM_LIST][? global.invItem[_slot][0]][? ITEM_TYPE] != WEAPON_INF);
		if (!_useAmmo || global.invItem[_slot][1] > 0){ // Ammo still remains in the magazine OR the weapon doesn't consume ammo
			if (player_use_weapon(_useAmmo)) {set_cur_state(player_state_weapon_recoil);}
		} else if (inventory_count(ammoTypes[| curAmmoType[? global.invItem[_slot][0]]]) > 0) { // The current weapon is out of ammunition; attempt to reload it
			set_cur_state(player_state_weapon_reload);
		}
		return; // Exit out of the state early
	}
	
	// Setting the sprite for the entity -- relative to direction that they are facing.
	if (inputMagnitude != 0) {direction = inputDirection;}
	entity_set_sprite(standSprite, 4); // TODO -- SWAP WITH WEAPON'S READY SPRITE
}

/// @description The state that the player is in whenever they are reloading their current weapon OR are
/// swapping between the weapon's different ammunition types. It plays the equipped weapon's reload animation
/// while also counting up a timer for the reload's duration. After the timer has surpassed the wepaon's
/// reload rate AND the ammo's reload rate modifier, the weapon will have its ammo swapped or be reloaded.
function player_state_weapon_reload(){
	var _reloadRate = reloadRate - reloadRateMod;
	
	// Counting up the timer for the reload to actually occur
	reloadTimer += global.deltaTime;
	if (reloadTimer >= _reloadRate){
		reloadTimer = 0; // Reset the reload timer
		player_reload_weapon(global.invItem[equipSlot[EquipSlot.Weapon]][1]);
		// Finally, revert the player back to their previous state
		if (keyReadyWeapon) {set_cur_state(player_state_weapon_ready);}
		else {set_cur_state(player_state_default);}
		return; // Exit out of the state early
	}
	
	// Overwrite the sprite's index with a index relative to the remaining reload time
	if (entity_set_sprite(walkSprite, 4)) {sprSpeed = 0;}
	localFrame = min((1 - ((_reloadRate - reloadTimer) / _reloadRate)) * sprFrames, sprFrames - 1);
}

/// @description The state the player is in during their weapon recoiling state, which occurs as the complete
/// attack animation for any melee weapon, and just the recoil animation of any firearms. The speed of the
/// animation is determined by the speed of the weapon's firerate, where 60 = one second of real-time.
function player_state_weapon_recoil(){
	var _fireRate = fireRate - fireRateMod;
	
	// Counting up the timer for the recoil to finish
	fireRateTimer += global.deltaTime;
	if (fireRateTimer >= _fireRate){
		fireRateTimer = 0; // Reset the fire rate timer
		set_cur_state(player_state_weapon_ready);
		return; // Exit out of the state early
	}
	
	// Overwrite the sprite's index with a index relative to the remaining recoil time
	if (entity_set_sprite(walkSprite, 4)) {sprSpeed = 0;}
	localFrame = min((1 - ((_fireRate - fireRateTimer) / _fireRate)) * sprFrames, sprFrames - 1);
}