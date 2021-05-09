/// @description The function that handles equipping any item that has valid data within the "Equipable Data"
/// section of the "item_data.json" file. It will attempt to parse out the script it needs to run for that
/// item, and if it can't find a valid script tied to the item it won't be euqipped at all. The function
/// will also prevent attempts to equip the same item onto the player character again.
/// @param slot
function player_equip_item(_slot){
	// Don't allow the function to execute anything if the slot provided is outside of the valid range OR
	// if the item in the slot is already equipped
	if (_slot < 0 || _slot > array_length(global.invItem) || global.invItem[_slot][3]) {return;}
	
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
		script_execute(_script, _slot);
		global.invItem[_slot][3] = true; // Set the equipped flag on the item to true
	}
}

/// @description The function that handles unequipping any item that is currently flagged as equipped onto
/// the player character. It will also attempt to parse a script's index out of the data provided like the
/// above function; resulting in no item being unequipped if it can't find a valid script. This function will
/// also prevent the player from unequipping items that aren't actually flagged as equipped.
/// @param slot
function player_unequip_item(_slot){
	// Don't allow the function to execute anything if the slot provided is outside of the valid range OR
	// if the item in the slot provided isn't equipped.
	if (_slot < 0 || _slot > array_length(global.invItem) || !global.invItem[_slot][3]) {return;}
	
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
		script_execute(_script);
		global.invItem[_slot][3] = true; // Set the equipped flag on the item to false
	}
}

/// @description 
/// @param slot
function player_equip_weapon(_slot){
	// If another weapon was currently equipped to the player, reset all the modifier values back to 0 and
	// also clear the list containing the names of all the different ammunition types.
	if (equipSlot[EquipSlot.Weapon] != -1){
		global.invItem[equipSlot[EquipSlot.Weapon]][3] = false;
		damageMod =			0;
		rangeMod =			0;
		accuracyMod =		0;
		fireRateMod =		0;
		reloadRateMod =		0;
		ammoTypes =		   -1;
	}
	
	// After the modifier data is cleared or it didn't need to be cleared in the first place, get the weapon's
	// data based on its name and add its data to the player's weapon stat vairables.
	var _data = global.itemData[? WEAPON_DATA][? global.invItem[_slot][0]];
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
	
	// Get the stats for the ammo that is currently inside of the weapon
	player_get_ammo_stats(global.invItem[_slot][0]);
	
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
	
	// Finally, set the equipped item's slot to the weapon's current slot
	equipSlot[EquipSlot.Weapon] = _slot;
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
	
	// Finally, reset the weapon's equipped slot value
	equipSlot[EquipSlot.Weapon] = -1;
}

/// @description 
/// @param slot
function player_equip_flashlight(_slot){
	// Set the player variables for the flashlight's characteristics, for when it's toggled on from off
	// after already being equipped, which is entirely possible by pressing the flashlight key.
	var _data = global.itemData[? FLASHLIGHT_DATA][? global.invItem[_slot][0]];
	if (is_undefined(_data)) {return;} // Exit the script if an invalid item was provided.
	lightSize =			_data[? SIZE];
	lightStrength =		_data[? STRENGTH];
	lightColor =		make_color_rgb(_data[? COLOR][| 0], _data[? COLOR][| 0], _data[? COLOR][| 2]);
	isLightActive =		true;
	// Update the light and set the lightActive variable to true, to let the game know it is on.
	light_update_settings(ambLight, lightSize, lightSize, lightStrength, lightColor);
	
	// Finally, set the equipped item's slot to the flashlight's current slot
	equipSlot[EquipSlot.Flashlight] = _slot;
}

/// @description 
function player_unequip_flashlight(){
	light_update_settings(ambLight, 15, 15, 0.05, c_ltgray);
	
	// Finally, reset the flashlight's equipped slot value
	equipSlot[EquipSlot.Flashlight] = -1;
}

/// @description 
/// @param slot
function player_equip_armor(_slot){
	// Unequip the previous armor if one is currently equipped by the player
	if (equipSlot[EquipSlot.Armor] != -1){
		global.invItem[equipSlot[EquipSlot.Armor]][3] = false;
		player_unequip_armor();
	}
	
	// Get the stats for the armor that is being equipped, which is the damage resistance and maximum 
	// speed modifier values.
	var _data = global.itemData[? ARMOR_DATA][? global.invItem[_slot][0]];
	if (is_undefined(_data)) {return;} // Exit the script if an invalid item was provided.
	entity_update_max_speed(-maxHspdConst * _data[? SPEED_MODIFIER], -maxVspdConst * _data[? SPEED_MODIFIER]); 
	damageResistance -= _data[? DAMAGE_RESIST];
	
	// Finally, set the equipped item's slot to the armor's current slot
	equipSlot[EquipSlot.Armor] = _slot;
}

/// @description 
function player_unequip_armor(){
	// Exit the function if no armor is currently equipped in the provided slot
	if (equipSlot[EquipSlot.Armor] == -1) {return;}
	
	// Only unequip the armor and restore the player's original stats if it is the same armor that is
	// equipped to them currently.
	var _data = global.itemData[? ARMOR_DATA][? global.invItem[equipSlot[EquipSlot.Armor]][0]];
	if (is_undefined(_data)) {return;} // Exit the script if an invalid item was provided.
	entity_update_max_speed(maxHspdConst * _data[? SPEED_MODIFIER], maxVspdConst * _data[? SPEED_MODIFIER]); 
	damageResistance += _data[? DAMAGE_RESIST];
	
	// Finally, reset the armor's equipped slot value
	equipSlot[EquipSlot.Armor] = -1;
}

/// @description 
/// @param slot
/// @param data
function player_equip_amulet(_slot, _data){
	if (equipSlot[EquipSlot.AmuletOne] == _slot || equipSlot[EquipSlot.AmuletTwo] == _slot){
		return; // Don't equip the amulet if it's already equipped to the player.
	}
	
	// If an amulet exists within the second slot currently, unequip that amulet and remove its effect.
	if (equipSlot[EquipSlot.AmuletTwo] != -1){
		player_unequip_item(equipSlot[EquipSlot.AmuletTwo]);
	}
	
	// Get the amulet's script arguments and execute the script's code for unequipping the amulet.
	if (!is_undefined(_data[? EQUIP_SCRIPT])){
		var _script = asset_get_index(_data[? EQUIP_SCRIPT]);
		// Before executing the script found inside of the data map, make sure it actually exists as an asset.
		// Only if it exists will the amulet be equipped onto the player.
		if (script_exists(_script)) {script_execute(_script);}
	}
	global.invItem[_slot][3] = true; // Set the equipped flag on the item to true
	
	// Finally, push whatever secondary amulet was previously equipped into the first slot into the second slot.
	equipSlot[EquipSlot.AmuletTwo] = equipSlot[EquipSlot.AmuletOne];
	equipSlot[EquipSlot.AmuletOne] = _slot;
}

/// @description 
/// @param slot
/// @param data
function player_unequip_amulet(_slot, _data){
	// Get the amulet's script arguments and execute the script's code for unequipping the amulet.
	if (!is_undefined(_data[? UNEQUIP_SCRIPT])){
		var _script = asset_get_index(_data[? UNEQUIP_SCRIPT]);
		// Before executing the script found inside of the data map, make sure it actually exists as an asset.
		// Only if it exists will the amulet be unequipped from the player.
		if (script_exists(_script)) {script_execute(_script);}
	}
	global.invItem[_slot][3] = false; // Set the equipped flag on the item to false
	
	// If the amulet that is being unequipped is in the first slot; move the second slot's amulet into the
	// the first amulet's slot after unequipping the amulet in the first slot.
	equipSlot[EquipSlot.AmuletOne] = equipSlot[EquipSlot.AmuletTwo];
	equipSlot[EquipSlot.AmuletTwo] = -1;
}

/// @description Swaps the equipped slot(s) to another value. This is useful when switching items between slots
/// in the inventory, since these values need to be updated in order to accurately reflect the item's new
/// position within the inventory.
/// @param oldSlot
/// @param newSlot
function player_update_equip_slot(_oldSlot, _newSlot){
	for (var i = 0; i < EquipSlot.Length; i++){
		// Check if the slot is equal to both the old slot and the new slot so switching two equipped items
		// can be handled in a single function call.
		if (equipSlot[i] == _oldSlot) {equipSlot[i] = _newSlot;}
		else if (equipSlot[i] == _newSlot) {equipSlot[i] = _oldSlot;}
	}
}

/// @description Attempts to swap to the next ammunition type that the weapon can take. If the player
/// doesn't have any ammunition of the other type(s) currently in their inventory, the ammo won't be
/// swapped. Also, when the item is being swapped it will attempt to place the previous ammunition into
/// the inventory after removing the necessary amount of the new ammo type from the inventory. If the old
/// ammo can't fit in the inventory it will be placed onto the floor as a collectable item for later.
/// @param prevAmmoType
function player_swap_current_ammo(_prevAmmoType){
	var _name = global.invItem[equipSlot[EquipSlot.Weapon]][0];
	
	// Instantly move onto the next ammo type before beginning the loop
	curAmmoType[? _name]++;
	
	// Loop until the current ammo type wraps around to the previous OR another ammo type was found
	var _length, _slot;
	_length = ds_list_size(ammoTypes);
	while(curAmmoType[? _name] != _prevAmmoType){
		// Some ammo was found for the other ammunition type, put it in the weapon and exit the loop
		if (inventory_count(ammoTypes[| curAmmoType[? _name]]) > 0){
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
			player_get_ammo_stats(_name);
			return true;
		}
		// Increment the current ammunition type, and wrap it back to the 0 if necessary
		curAmmoType[? _name]++;
		if (curAmmoType[? _name] >= _length){
			curAmmoType[? _name] = 0;
		}
	}
	
	// No ammunition could be swapped; return false
	return false;
}

/// @description
/// @param name
/// @param index
function player_get_ammo_stats(_name){
	// Don't bother even executing the code if the provided index value is out of range.
	if (is_undefined(curAmmoType[? _name])) {return;}
	// Fetch the ammunition's stat modifying values based on the index provided, but only set the values if
	// the data returned from the ammunition data is an existing map in the structure.
	var _statModifier = global.itemData[? AMMO_DATA][? ammoTypes[| curAmmoType[? _name]]];
	if (!is_undefined(_statModifier)){
		damageMod =		_statModifier[? DAMAGE_MOD];
		rangeMod =		_statModifier[? RANGE_MOD];
		accuracyMod =	_statModifier[? ACCURACY_MOD];
		fireRateMod =	_statModifier[? FIRE_RATE_MOD];
		reloadRateMod = _statModifier[? RELOAD_RATE_MOD];
		return;
	}
	// No valid modifier values exist for the ammunition that was provided; set all values to zero.
	damageMod =		0;
	rangeMod =		0;
	accuracyMod =	0;
	fireRateMod =	0;
	reloadRateMod = 0;
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
		_weaponData = [global.invItem[_slot][0], player_get_weapon_damage(), range + rangeMod, bulletSpd];
		
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
	
	// Finally, subtract one from the weapon's current magazine amount if it consumes ammo. The only exception
	// to this is when the player has the refund amulet equipped, which has a 33% chance of not consuming ammo.
	if (_useAmmo){
		global.invItem[_slot][1]--;
		if (player_is_amulet_equipped(REFUND_AMULET)){
			var _refundChance = irandom_range(1, 100); // Choses a number between 1 and 100 for refund chance
			if (_refundChance <= 33) {global.invItem[_slot][1]++;}
		}
	}
	
	// Return that the weapon was successfully used by the player
	return true;
}

/// @description Reloads the player's currently equipped weapon. It does so by calculating the space for
/// ammunition remaining within the gun's magazine and then attempts to remove that amount from the ammo
/// found in the inventory. Finally, it takes the remainder that couldn't be pulled from the inventory and
/// subtracts that from the maximum magazine size.
/// @param clipRemainder
function player_reload_weapon(_clipRemainder){
	var _slot, _name, _maxQuantity, _remainder;
	_slot = equipSlot[EquipSlot.Weapon];
	_name = global.invItem[_slot][0];
	_maxQuantity = global.itemData[? ITEM_LIST][? _name][? MAX_STACK];
	_remainder = inventory_remove(ammoTypes[| curAmmoType[? _name]], _maxQuantity - _clipRemainder);
	global.invItem[_slot][1] = _maxQuantity - _remainder;
}

/// @description Simply returns the final damage that the player will deal out with their weapon, which is
/// a sum of the weapon's base damage and its ammunition modifier value, as well as the damage multiplier
/// and the difficulty's damage modifier.
function player_get_weapon_damage(){
	return (damage + damageMod) * damageMultiplier * global.gameplay.playerDamageMod;
}