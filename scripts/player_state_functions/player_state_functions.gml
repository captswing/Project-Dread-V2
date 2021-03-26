/// @description The player's default state. In a basic summary, the player is able to walk around at their
/// current full speed; with an optional boost to that speed if they are running. On top of that, the player
/// can swap out the ammunition on their currently equipped gun, aim/ready their weapon, and interact with
/// nearby objects.
function player_state_default(){
	// Toggling the equipped flashlight on and off
	if (keyFlashlight && equipSlot[EquipSlot.Flashlight] != NO_ITEM){
		isLightActive = !isLightActive;
		if (isLightActive){ // Turning the flashlight back on with the stored settings
			update_light_settings(ambLight, lightSize, lightSize, lightStrength, lightColor);
		} else{ // Turning the flashlight back into the dim ambient light
			update_light_settings(ambLight, 15, 15, 0.01, c_ltgray);
		}
	}
	
	// Interacting with certain objects in the world
	if (keyInteract){
		var _offset = [4 * (keyRight - keyLeft), (12 * (keyDown - keyUp)) - 2];
		with(instance_nearest(x + _offset[X], y + _offset[Y], par_interactable)){
			if (canInteract && interactScript != NO_SCRIPT){
				script_execute(interactScript);
			}
		}
	}
	
	// Controls that relate to the player's currently equipped weapon
	if (weaponSlot != -1 && global.invItem[weaponSlot][0] != NO_ITEM){
		// Readying the player's currently equipped weapon
		if (keyReadyWeapon){
			set_cur_state(player_state_weapon_ready);
			return; // Exit the current state early
		}
	
		// Controls that only apply to weapons that consume ammo when used
		if (global.itemData[? ITEM_LIST][? global.invItem[weaponSlot][0]][? ITEM_TYPE] != WEAPON_INF){
			// Reloading the player's currently equipped weapon
			if (keyReload && global.invItem[weaponSlot][1] < global.itemData[? ITEM_LIST][? global.invItem[weaponSlot][0]][? MAX_STACK]){
				// Only reload if the invenotry contains spare ammunition
				if (inventory_count(ammoTypes[| curAmmoType]) > 0) {set_cur_state(player_state_weapon_reload);}
				return; // Exit the current state early
			}
			
			// Swapping the player's currently equipped ammunition
			if (keyAmmoSwap && ds_list_size(ammoTypes) > 1){
				if (player_swap_current_ammo(curAmmoType)) {set_cur_state(player_state_weapon_reload);}
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
		set_sprite(spr_claire_unarmed_walk, 4);
		// TODO -- Add change to running sprite here
		direction = inputDirection;
	} else{ // The player is standing still; don't update direction based on input
		set_sprite(spr_claire_unarmed_stand, 4);
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
		var _useAmmo = (global.itemData[? ITEM_LIST][? global.invItem[weaponSlot][0]][? ITEM_TYPE] != WEAPON_INF);
		if (!_useAmmo || global.invItem[weaponSlot][1] > 0){ // Ammo still remains in the magazine OR the weapon doesn't consume ammo
			set_cur_state(player_state_weapon_recoil);
			player_use_weapon(_useAmmo);
		} else if (inventory_count(ammoTypes[| curAmmoType]) > 0) { // The current weapon is out of ammunition; attempt to reload it
			set_cur_state(player_state_weapon_reload);
		}
		return; // Exit out of the state early
	}
	
	// Setting the sprite for the entity -- relative to direction that they are facing.
	if (inputMagnitude != 0) {direction = inputDirection;}
	set_sprite(spr_claire_unarmed_stand, 4); // TODO -- SWAP WITH WEAPON'S READY SPRITE
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
		reloadTimer = 0; // Reset the reload timer and local frame
		player_reload_weapon(global.invItem[weaponSlot][1]);
		// Finally, revert the player back to their previous state
		set_cur_state(lastState);
		set_sprite(spr_claire_unarmed_stand, 4);
		return; // Exit out of the state early
	}
	
	// Overwrite the sprite's index with a index relative to the remaining reload time
	if (set_sprite(spr_claire_unarmed_walk, 4)) {sprSpeed = 0;}
	localFrame = min((1 - ((_reloadRate - reloadTimer) / _reloadRate)) * sprFrames, sprFrames - 1);
}

/// @description
function player_state_weapon_recoil(){
	var _fireRate = fireRate - fireRateMod;
	
	// Counting up the timer for the recoil to finish
	fireRateTimer += global.deltaTime;
	if (fireRateTimer >= _fireRate){
		fireRateTimer = 0; // Reset the fire rate timer and local frame
		set_cur_state(lastState);
		set_sprite(spr_claire_unarmed_stand, 4);
		return; // Exit out of the state early
	}
	
	// Overwrite the sprite's index with a index relative to the remaining recoil time
	if (set_sprite(spr_claire_unarmed_walk, 4)) {sprSpeed = 0;}
	localFrame = min((1 - ((_fireRate - fireRateTimer) / _fireRate)) * sprFrames, sprFrames - 1);
}