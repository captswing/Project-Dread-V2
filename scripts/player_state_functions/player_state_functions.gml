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
	
	// Interacting with certain objects in the world and updating the player's interaction point
	interactOffset = [x + lengthdir_x(8, direction), y + lengthdir_y(8, direction) - 4];
	if (keyInteract){ // Attempt to interact when the key for doing so is pressed
		var _offset = [interactOffset[X], interactOffset[Y]]; // Copy into a temporary array
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
	
	// Making the player collide with and push objects that are a weight taht is equal to or beneath what
	// the player character is actually able to push.
	if (inputMagnitude != 0){
		var _object = instance_place(x + sign(hspd), y + sign(vspd), par_movable_object);
		if (_object != noone){
			// Only begin pushing the object if the player is within 20 degress of one of the main cardinal 
			// directions. This means that movable objects can only be pushed in 4 total directions.
			var _pushDirection = 90 * floor(image_index / sprFrames);
			// Next, the player's bounding box position will be checked with the border of the pushable block's
			// bounding box to see if the player is within those bounds. This ensures weird collision mishaps
			// won't occur where the player gets stuck on a wall, but the block keeps moving since it hasn't
			// has a collision itself.
			var _canPushObject = false;
			if (_pushDirection == 0 || _pushDirection == 180) {_canPushObject = (bbox_top > _object.bbox_top && bbox_bottom < _object.bbox_bottom);}
			else if (_pushDirection == 90 || _pushDirection == 270) {_canPushObject = (bbox_left > _object.bbox_left && bbox_right < _object.bbox_right);}
			// If all the conditions are met, the player will begin pushing the object around
			if (_canPushObject && inputDirection >= _pushDirection - 20 && inputDirection <= _pushDirection + 20){
				set_cur_state(player_state_activate_push);
				pushDirection = _pushDirection;
				pushedObjectWeight = max(_object.weight, 1);
				pushedObjectID = _object; // Stores the ID to check if it's been destroyed or not
				return; // Exit the state early
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
	
	// Store the slot for the weapon and its name into temporary variables for better readibility
	var _slot, _name;
	_slot = equipSlot[EquipSlot.Weapon];
	_name = global.invItem[_slot][0];
	
	// Using the player's current weapon
	if (keyUseWeapon){
		var _useAmmo = (global.itemData[? ITEM_LIST][? _name][? ITEM_TYPE] != WEAPON_INF);
		if (!_useAmmo || global.invItem[_slot][1] > 0){ // Ammo still remains in the magazine OR the weapon doesn't consume ammo
			if (player_use_weapon(_useAmmo)) {set_cur_state(player_state_weapon_recoil);}
		} else if (inventory_count(ammoTypes[| curAmmoType[? _name]]) > 0) { // The current weapon is out of ammunition; attempt to reload it
			set_cur_state(player_state_weapon_reload);
		} else{ // The weapon can't be reloaded; play the empty clip sound on first key/button click
			var _keyUseWeapon = false;
			if (!global.gamepadActive) {_keyUseWeapon = keyboard_check_pressed(global.settings[Settings.UseWeapon]);}
			else {_keyUseWeapon = keyboard_check_pressed(global.settings[Settings.UseWeaponGP]);}
			// Prevents playing the audio again despite not clicking the use weapon key again
			if (_keyUseWeapon) {play_sound_effect(snd_empty_clip, 1, false);}
		}
		return; // Exit out of the state early
	}
	
	// Reloading the readied weapon if it uses ammunition and isn't infinite
	if (keyReload && global.invItem[_slot][1] < global.itemData[? ITEM_LIST][? _name][? MAX_STACK]){
		if (inventory_count(ammoTypes[| curAmmoType[? _name]]) > 0) {set_cur_state(player_state_weapon_reload);}
		return; // Exit the current state early
	}
	
	// Setting the sprite for the entity -- relative to direction that they are facing.
	if (inputMagnitude != 0) {direction = inputDirection;}
	entity_set_sprite(aimingSprite, 4);
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
		image_index = floor(direction / sprDirections);
		player_reload_weapon(global.invItem[equipSlot[EquipSlot.Weapon]][1]);
		// Finally, revert the player back to their previous state
		if (keyReadyWeapon) {set_cur_state(player_state_weapon_ready);}
		else {set_cur_state(player_state_default);}
		return; // Exit out of the state early
	}
	
	// Overwrite the sprite's index with a index relative to the remaining reload time
	if (entity_set_sprite(reloadSprite, 4)) {sprSpeed = 0;}
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
		image_index = floor(direction / sprDirections);
		set_cur_state(player_state_weapon_ready);
		return; // Exit out of the state early
	}
	
	// Overwrite the sprite's image index with one relative to the remaining recoil time
	if (entity_set_sprite(recoilSprite, 4)) {sprSpeed = 0;}
	localFrame = min((1 - ((_fireRate - fireRateTimer) / _fireRate)) * sprFrames, sprFrames - 1);
}

/// @description A simple state that will play an animation of the player entering their object pushing 
/// animation. This also allows the player to pull out of pushing the object before actually fully committing
/// to that state. It switches states once the counter hits the designated value set in the code.
function player_state_activate_push(){
	// Increment or decrement the timer depending on how if the player is holding the correct movement keys
	var _directionInRange = (inputDirection >= pushDirection - 20 && inputDirection <= pushDirection + 20);
	if (pushedObjectID != noone && inputMagnitude != 0 && _directionInRange) {pushAnimateTimer += global.deltaTime;}
	else {pushAnimateTimer -= global.deltaTime;}
	
	// The timer will be checked for its value going below 0 or above the number required to enter the pushing state
	if (pushAnimateTimer >= pushAnimateTime){ // The push state will be entered and the object will begin getting pushed
		set_cur_state(player_state_push_object);
		pushAnimateTimer = pushAnimateTime; // Max out the timer
	} else if (pushAnimateTimer <= 0){ // The player will not push the object and return to their default state
		set_cur_state(player_state_default);
		pushAnimateTimer = 0; // Ensure the timer doesn't end up below 0
	}
	
	// Overwrite the sprite's image index with one relative to how far along the animation timer is
	if (entity_set_sprite(walkSprite, 4)) {sprSpeed = 0;}
	localFrame = min((1 - ((pushAnimateTime - pushAnimateTimer) / pushAnimateTime)) * sprFrames, sprFrames - 1);
}

/// @description The state the player is in whenever they are pushing an object around. They will remain in
/// this state until the release the direction key that they held in order to activate the pushing state.
/// They will be unable to push more than one object at time, and they will also not be able to to push objects
/// that are coonsidered too heavy for them.
function player_state_push_object(){
	// Exiting the state by releasing the movement key for pushing the object. This returns it to the activate
	// push animation script, but it will work in reverse because of the conditions needed to return to it.
	var _directionInRange = (inputDirection >= pushDirection - 20 && inputDirection <= pushDirection + 20);
	if (inputMagnitude == 0 || !_directionInRange){
		set_cur_state(player_state_activate_push);
		pushedObjectID = noone;
		return; // Exit the state early
	}
	
	// Move the player and the object based on the weight of the object -- the heavier it is, the slower the
	// player will push it. This means every object can be pushed, but if its weight is too height it will
	// almost never move a pixel.
	hspd = lengthdir_x(maxHspd / pushedObjectWeight, pushDirection);
	vspd = lengthdir_y(maxVspd / pushedObjectWeight, pushDirection);
	remove_movement_fractions();
	
	// Move the block by the same amount as the player moves in a frame.
	var _objectExists, _velocity, _deltaVelocity;
	_objectExists = false;
	_velocity = [hspd, vspd];
	_deltaVelocity = [deltaHspd, deltaVspd];
	with(pushedObjectID){
		_objectExists = true; // Let's the player know the object still exists
		// Check for collision between this movable block and a wall at its next set position
		if (place_meeting(x + _deltaVelocity[X], y + _deltaVelocity[Y], par_collider)){
			hspd = sign(_velocity[X]);
			vspd = sign(_velocity[Y]);
			// Move pixel by pixel until the object reaches the wall
			while(!place_meeting(x + hspd, y + vspd, par_collider)){
				x += hspd;
				y += vspd;
			}
		} else{ // No collision occurred; update position
			x += _deltaVelocity[X];
			y += _deltaVelocity[Y];
		}
	}
	
	// If for some reason the object being pushed doesn't exists anymore, exit the pushing state
	if (!_objectExists){
		set_cur_state(player_state_activate_push);
		pushedObjectID = noone;
		return; // Exit the state early
	}
	
	// Finally, handle collision with the world's colliders
	entity_world_collision(false);
}