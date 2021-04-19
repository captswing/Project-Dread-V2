/// @description 
/// @param slot
function player_equip_item(_slot){
	// Don't allow the function to execute anything if the slot provided is outside of the valid range
	if (_slot < 0 || _slot > array_length(global.invItem)) {return;}
	
	// Store the item's equipment data into a variable and check if the item is an amulet, which uses
	// a slightly different function for equipping and unequipping.
	var _data = global.itemData[? EQUIPABLE_DATA][? global.invItem[_slot][0]];
	if (global.itemData[? ITEM_LIST][? global.invItem[_slot][0]][? ITEM_TYPE] == AMULET){
		player_equip_amulet(_slot, _data);
		return; // Exit the script early
	}
	
	// The item isn't an amulet, and thus uses the strandard equipment code.
	var _script = asset_get_index(_data[? EQUIP_SCRIPT]);
	// Before executing the script found inside of the data map, make sure it actually exists as an asset.
	// Only if it exists will the item be equipped onto the player.
	if (script_exists(_script)){
		var _array, _equipmentSlot;
		_array = ds_list_to_array(_data[? EQUIP_ARGUMENTS]);
		_equipmentSlot = script_execute_ext(_script, _array);
		global.invItem[_slot][3] = true; // Set the equipped flag on the item to true
		if (!is_undefined(_equipmentSlot)){ // Stores the equipment's name and its current slot 
			equipSlot[_equipmentSlot] = _slot;
		}
	}
}

/// @description 
/// @param slot
function player_unequip_item(_slot){
	// Don't allow the function to execute anything if the slot provided is outside of the valid range
	if (_slot < 0 || _slot > array_length(global.invItem)) {return;}
	
	// Store the item's equipment data into a variable and check if the item is an amulet, which uses
	// a slightly different function for equipping and unequipping.
	var _data = global.itemData[? EQUIPABLE_DATA][? global.invItem[_slot][0]];
	if (global.itemData[? ITEM_LIST][? global.invItem[_slot][0]][? ITEM_TYPE] == AMULET){
		player_unequip_amulet(_slot, _data);
		return; // Exit the script early
	}
	
	// The item isn't an amulet, and thus uses the strandard equipment unequipping code.
	var	_script = asset_get_index(_data[? UNEQUIP_SCRIPT]);
	// Before executing the script found inside of the data map, make sure it actually exists as an asset.
	// Only if it exists will the item be attempted to be unequipped from the player.
	if (script_exists(_script)){
		var _array, _equipmentSlot;
		_array = ds_list_to_array(_data[? UNEQUIP_ARGUMENTS]);
		_equipmentSlot = script_execute_ext(_script, _array);
		global.invItem[_slot][3] = true; // Set the equipped flag on the item to false
		if (!is_undefined(_equipmentSlot)){ // Remove the equipment's data from its slot
			equipSlot[_equipmentSlot] = -1;
		}
	}
}

/// @description 
/// @param name
function player_equip_weapon(_name){
	// If another weapon was currently equipped to the player, reset all the modifier values back to 0 and
	// also clear the list containing the names of all the different ammunition types.
	if (equipSlot[EquipSlot.Weapon] != -1){
		global.invItem[equipSlot[EquipSlot.Weapon]][3] = false;
		damageMod =			0;
		rangeMod =			0;
		accuracyMod =		0;
		fireRateMod =		0;
		reloadRateMod =		0;
		curAmmoType =		0;
		ammoTypes =		   -1;
	}
	
	// After the modifier data is cleared or it didn't need to be cleared in the first place, get the weapon's
	// data based on its name and add its data to the player's weapon stat vairables.
	var _data = global.itemData[? WEAPON_DATA][? _name];
	if (is_undefined(_data)) {return;} // Exit the script if an invalid item was provided.
	damage =				_data[? DAMAGE];
	numBullets =			_data[? NUM_BULLETS];
	range =					_data[? RANGE];
	accuracy =				_data[? ACCURACY];
	fireRate =				_data[? FIRE_RATE];
	reloadRate =			_data[? RELOAD_RATE];
	bulletSpd =				_data[? BULLET_SPEED];
	startFrame =			_data[? START_FRAME];
	endFrame =				_data[? END_FRAME];
	ammoTypes =				_data[? AMMO_TYPES];
	
	// Since the weapon sprite/sound data is stored in lists within the weapon data, we need to pull it out
	// of the lists and into individual variables.
	var _sounds = _data[? SOUNDS]; // Gathering the sound data
	weaponUseSound =		asset_get_index(_sounds[| 0]);
	weaponReloadSound =		asset_get_index(_sounds[| 1]);
	var _sprites = global.itemData[? WEAPON_DATA][? INF_CHAINSAW][? SPRITES]; // Gathering the sprite data
	standSprite =			asset_get_index(_sprites[| 0]);
	walkSprite =			asset_get_index(_sprites[| 1]);
	aimingSprite =			asset_get_index(_sprites[| 2]);
	recoilSprite =			asset_get_index(_sprites[| 3]);
	reloadSprite =			asset_get_index(_sprites[| 4]);
	
	// Finally, return the equipment slot that a weapon is placed into
	return EquipSlot.Weapon;
}

/// @description 
function player_unequip_weapon(){
	// Reset all the main weapon variables, which store the initial stats and ammunition types.
	damage =				0;
	numBullets =			0;
	range =					0;
	accuracy =				0;
	fireRate =				0;
	reloadRate =			0;
	bulletSpd =				0;
	startFrame =			0;
	endFrame =				0;
	curAmmoType =			0;
	ammoTypes =			   -1;
	
	// Also, reset the sound variables to -1 and all sprites back to Claire's unarmed sprites. There are
	// no sprites for aiming, firing, and reloding when no weapon is equipped, so using those sprites while
	// Claire in unarmed will result in a crash.
	weaponUseSound =       -1;
	weaponReloadSound =    -1;
	standSprite =			spr_claire_unarmed_stand;
	walkSprite =			spr_claire_unarmed_walk;
	aimingSprite =		   -1;
	recoilSprite =		   -1;
	reloadSprite =		   -1;
	
	// Finally, return the equipment slot that a weapon was removed from
	return EquipSlot.Weapon;
}

/// @description 
/// @param name
function player_equip_flashlight(_name){
	// Set the player variables for the flashlight's characteristics, for when it's toggled on from off
	// after already being equipped, which is entirely possible by pressing the flashlight key.
	var _data = global.itemData[? FLASHLIGHT_DATA][? _name];
	if (is_undefined(_data)) {return;} // Exit the script if an invalid item was provided.
	lightSize =			_data[? SIZE];
	lightStrength =		_data[? STRENGTH];
	lightColor =		make_color_rgb(_data[? COLOR][| 0], _data[? COLOR][| 0], _data[? COLOR][| 2]);
	isLightActive =		true;
	// Update the light and set the lightActive variable to true, to let the game know it is on.
	update_light_settings(ambLight, lightSize, lightSize, lightStrength, lightColor);
	
	// Finally, return the equipment slot that a flashlight is placed into
	return EquipSlot.Flashlight;
}

/// @description 
function player_unequip_flashlight(){
	update_light_settings(ambLight, 15, 15, 0.05, c_ltgray);
	
	// Finally, return the equipment slot that a flashlight was removed from
	return EquipSlot.Flashlight;
}

/// @description 
/// @param name
function player_equip_armor(_name){
	// Unequip the previous armor if one is currently equipped by the player
	if (equipSlot[EquipSlot.Armor] != NO_ITEM){
		var _slot = inventory_find_equipped_item(equipSlot[EquipSlot.Armor]);
		global.invItem[_slot][3] = false;
		player_unequip_armor(equipSlot[EquipSlot.Armor]);
	}
	
	// Get the stats for the armor that is being equipped, which is the damage resistance and maximum 
	// speed modifier values.
	var _data = global.itemData[? ARMOR_DATA][? _name];
	if (is_undefined(_data)) {return;} // Exit the script if an invalid item was provided.
	entity_update_max_speed(-maxHspdConst * _data[? SPEED_MODIFIER], -maxVspdConst * _data[? SPEED_MODIFIER]); 
	damageResistance -= _data[? DAMAGE_RESIST];
	
	// Finally, return the equipment slot that the armor is placed into
	return EquipSlot.Armor;
}

/// @description 
/// @param name
function player_unequip_armor(_name){
	// Exit the function if the armor that is equipped doesn't match the provided name or no armor is equipped
	if (_name == NO_ITEM || equipSlot[EquipSlot.Armor] != _name) {return;}
	
	// Only unequip the armor and restore the player's original stats if it is the same armor that is
	// equipped to them currently.
	var _data = global.itemData[? ARMOR_DATA][? _name];
	entity_update_max_speed(maxHspdConst * _data[? SPEED_MODIFIER], maxVspdConst * _data[? SPEED_MODIFIER]); 
	damageResistance += _data[? DAMAGE_RESIST];
	
	// Finally, return the equipment slot that the armor was removed from
	return EquipSlot.Armor;
}

/// @description
/// @param slot
/// @param data
function player_equip_amulet(_slot, _data){
	// If an amulet exists within the second slot currently, unequip that amulet and remove its effect.
	if (equipSlot[EquipSlot.AmuletTwo] != -1){
		player_unequip_item(equipSlot[EquipSlot.AmuletTwo]);
	}
	
	// If the amulet is already equipped to either slot, don't equip the item again. Instead, move it to
	// the first slot and the first slot's amulet to the second or just exit the script if it's already
	// in the first slot.
	if (equipSlot[EquipSlot.AmuletTwo][1] == _slot){
		var _temp = equipSlot[EquipSlot.AmuletOne];
		equipSlot[EquipSlot.AmuletOne] = equipSlot[EquipSlot.AmuletTwo];
		equipSlot[EquipSlot.AmuletTwo] = _temp;
		return; // Exit out of the script without equiping the amulet again.
	} else if (equipSlot[EquipSlot.AmuletOne] == _slot){
		return; // Simply exit the script without equipping the amulet.
	}
	
	// Get the amulet's script arguments and execute the script's code for equipping the amulet.
	var _script = asset_get_index(_data[? EQUIP_SCRIPT]);
	// Before executing the script found inside of the data map, make sure it actually exists as an asset.
	// Only if it exists will the item be equipped onto the player.
	if (script_exists(_script)){
		var _array = ds_list_to_array(_data[? EQUIP_ARGUMENTS]);
		script_execute_ext(_script, _array);
		global.invItem[_slot][3] = false; // Set the equipped flag on the item to false
	}
	
	// Finally, push whatever secondary amulet was previously equipped into the first slot into the second slot.
	equipSlot[EquipSlot.AmuletTwo] = equipSlot[EquipSlot.AmuletOne];
	equipSlot[EquipSlot.AmuletOne] = _slot;
}

/// @description
/// @param slot
/// @param data
function player_unequip_amulet(_slot, _data){
	
}

/// @description Attempts to swap to the next ammunition type that the weapon can take. If the player
/// doesn't have any ammunition of the other type(s) currently in their inventory, the ammo won't be
/// swapped. Also, when the item is being swapped it will attempt to place the previous ammunition into
/// the inventory after removing the necessary amount of the new ammo type from the inventory. If the old
/// ammo can't fit in the inventory it will be placed onto the floor as a collectable item for later.
/// @param prevAmmoType
function player_swap_current_ammo(_prevAmmoType){
	// Instantly move onto the next ammo type before beginning the loop
	curAmmoType++;
	
	// Loop until the current ammo type wraps around to the previous OR another ammo type was found
	var _length, _slot;
	_length = ds_list_size(ammoTypes);
	while(curAmmoType != _prevAmmoType){
		// Some ammo was found for the other ammunition type, put it in the weapon and exit the loop
		if (inventory_count(ammoTypes[| curAmmoType]) > 0){
			// Attempt to add the previous bullets to the inventory. If they can't be added to the inventory 
			// because there isn't enough space, add the remainder to an item and place it in the world.
			_slot = equipSlot[EquipSlot.Weapon];
			if (global.invItem[_slot][1] > 0){
				var _remainder = inventory_add(ammoTypes[| _prevAmmoType], global.invItem[_slot][1], 0);
				if (_remainder > 0){ // Attempt to create the object at the player's feet. Create in room's center if that isn't possible
					var _player = global.singletonID[? PLAYER];
					if (_player != noone) {create_item(x, y, ammoTypes[| _prevAmmoType], _remainder, 0);}
					else {create_item(round(room_width / 2), round(room_height / 2), ammoTypes[| _prevAmmoType], _remainder, 0);}
				}
				// Also, remove all the ammunition from the weapon's current clip
				global.invItem[_slot][1] = 0;
			}
			// Finally, fetch the ammo's modification stats and apply them to their respective stats
			var _statModifier = global.itemData[? AMMO_DATA][? ammoTypes[| curAmmoType]];
			if (!is_undefined(_statModifier)){
				damageMod =		_statModifier[? DAMAGE_MOD];
				rangeMod =		_statModifier[? RANGE_MOD];
				accuracyMod =	_statModifier[? ACCURACY_MOD];
				fireRateMod =	_statModifier[? FIRE_RATE_MOD];
				reloadRateMod = _statModifier[? RELOAD_RATE_MOD];
				return true;
			}
			// No stat modification data exists for the ammunition; set them all back to 0
			damageMod =		0;
			rangeMod =		0;
			accuracyMod =	0;
			fireRateMod =	0;
			reloadRateMod = 0;
			return true;
		}
		// Increment the current ammunition type, and wrap it back to the 0 if necessary
		curAmmoType++;
		if (curAmmoType >= _length){
			curAmmoType = 0;
		}
	}
	
	// No ammunition could be swapped; return false
	return false;
}

/// @description Using the player's current weapon. The effect of the weapon can either be a hitscan attack
/// in the same frame, a projectile that travels until either a collision occurs or the weapon's range has
/// been exceeded, or a melee hitbox that is destroyed after the animation reaches a certain point.
/// @param useAmmo
function player_use_weapon(_useAmmo){
	// Store the slot index into a variable to save on typing
	var _slot = equipSlot[EquipSlot.Weapon];
	
	// Handling weapon durability if it is toggled for the selected difficulty setting
	if (global.gameplay.weaponDurability){
		if (global.invItem[_slot][2] == 0){
			return false; // The weapon is broken and cannot be used anymore
		}
		// If there is still some weapon durability left, subtract one from the total
		global.invItem[_slot][2]--;
	}
	
	// Each of the three weapon possibilities: hitscan, projectile, and melee. They each cause a different 
	// thing to occur when the respective weapon is used.
	if (startFrame == endFrame && bulletSpd == 0){ // Using a hitscan weapon (All ranged attacks excluding grenade launcher)
		// Create as many bullets that are necessary for the equipped weapon
		for (var i = 0; i < numBullets; i++){
			var _direction, _endX, _endY; // Calculate the bullet's trajectory
			_direction = direction + random_range(-(accuracy - accuracyMod), accuracy - accuracyMod);
			_endX = x + lengthdir_x(range + rangeMod, _direction);
			_endY = y + lengthdir_y(range + rangeMod, _direction);
			// Next, take the information and handle the collisions found by the hitscan
			player_attack_hitscan_collision(x, y, _endX, _endY, 8);
		}
	} else if (startFrame < endFrame && startFrame >= 0){ // Using a melee weapon (All melee weapons including the chainsaw)
		// TODO -- Add melee hitbox stuff here
	} else if (bulletSpd > 0){ // Using a projectile weapon (Basically, only the grenade launcher's ammo)
		var _direction, _object, _weaponData;
		_direction = direction + random_range(-(accuracy - accuracyMod), accuracy - accuracyMod);
		_object = instance_create_depth(x + lengthdir_x(6, direction), y + lengthdir_y(10, direction), ENTITY_DEPTH, obj_player_projectile);
		_weaponData = [global.invItem[_slot][0], damage + damageMod, range + rangeMod, bulletSpd];
		// Pull all the necessary data in from the weapon to the projectile, which basically means
		// the range and damage of the bullet.
		with(_object){
			// Pull in the weapon's name, damage, range, and movement speed (Relative to its direction)
			weaponName =	_weaponData[0];
			damage =		_weaponData[1];
			range =			_weaponData[2];
			hspd =			lengthdir_x(_weaponData[3], _direction);
			vspd =			lengthdir_y(_weaponData[3], _direction);
			// Set the variables that track the distance the bullet has travelled relative to its max range
			startX =		x;
			startY =		y;
			// Next, set the state to handle the projectile movement for the weapon
			set_cur_state(player_attack_state_projectile);
			image_angle = _direction;
		}
	}
	
	// Play the weapon's use sound effect. Nothing will play if the provided sound doesn't exist
	play_sound_effect(weaponUseSound, get_audio_group_volume(Settings.Sounds), true);
	// Finally, subtract one from the weapon's current magazine amount if it consumes ammo
	if (_useAmmo) {global.invItem[_slot][1]--;}
	
	// Return that the weapon was successfully used by the player
	return true;
}

/// @description Reloads the player's currently equipped weapon. It does so by calculating the space for
/// ammunition remaining within the gun's magazine and then attempts to remove that amount from the ammo
/// found in the inventory. Finally, it takes the remainder that couldn't be pulled from the inventory and
/// subtracts that from the maximum magazine size.
/// @param clipRemainder
function player_reload_weapon(_clipRemainder){
	var _slot, _maxQuantity, _remainder;
	_slot = equipSlot[EquipSlot.Weapon];
	_maxQuantity = global.itemData[? ITEM_LIST][? global.invItem[_slot][0]][? MAX_STACK];
	_remainder = inventory_remove(ammoTypes[| curAmmoType], _maxQuantity - _clipRemainder);
	global.invItem[_slot][1] = _maxQuantity - _remainder;
}