/// @description Attemps to equip the item within the slot that was provided. If the item in that slot isn't
/// able to be equiped by the player, nothing will occur. Otherwise, the item's type will be parsed and the
/// item will be equipped to the correct slot in the player's equipment array.
/// @param slot
/// @param itemType
function player_equip_item(_slot, _itemType){
	// If an invalid slot value was given, don't attempt to equip the item
	if (_slot < 0 || _slot >= array_length(global.invItem)){
		return false;
	}
	
	// This flag lets the function know whether the item was successfully equipped to the player or not.
	var _itemEquipped = true;
	
	// Always attempt to unequip the weapon from the necessary slot. This prevents multiple
	// items to have their effects active in a single slot.
	player_unequip_item(_slot, _itemType);
	
	switch(_itemType){
		case WEAPON: // Equipping a gun/melee weapon
		case WEAPON_INF:
			// Get the wepaon's stats and apply them to the player's variables
			var _data = global.itemData[? WEAPON_DATA][? global.invItem[_slot][0]];
			weaponSlot =	_slot;
			damage =		_data[? DAMAGE];
			numBullets =	_data[? NUM_BULLETS];
			range =			_data[? RANGE];
			accuracy =		_data[? ACCURACY];
			fireRate =		_data[? FIRE_RATE];
			reloadRate =	_data[? RELOAD_RATE];
			bulletSpd =		_data[? BULLET_SPEED];
			endFrame =		_data[? END_FRAME];
			ammoTypes =		_data[? AMMO_TYPES];
			
			// TODO -- Add sprite changes and other required code here.
			
			// Finally, place the name of the item into the equipment slot
			equipSlot[EquipSlot.Weapon] = global.invItem[_slot][0];
			break;
		case ARMOR: // Equipping protection onto the player
			if (global.invItem[_slot][0] == KEVLAR_VEST){ // The standard kevlar vest will slow the player down slightly
				entity_update_max_speed(-maxHspdConst * 0.35, -maxVspdConst * 0.35);
			}
			damageResistance -= 0.25;
			// Finally, place the name of the item into the equipment slot
			equipSlot[EquipSlot.Armor] = global.invItem[_slot][0];
			break;
		case LIGHT_SOURCE: // A light source that surrounds the player when equipped
			// The effectiveness of the light source differs between both flashlights; stats are located below
			if (global.invItem[_slot][0] == FLASHLIGHT){
				lightSize = 64;
				lightStrength = 0.9;
				lightColor = c_white;
			} else if (global.invItem[_slot][0] == BRIGHT_FLASHLIGHT){
				lightSize = 112;
				lightStrength = 1.15;
				lightColor = c_white;
			}
			update_light_settings(ambLight, lightSize, lightSize, lightStrength, lightColor);
			isLightActive = true; // Always turn the flashlight on when it's first equipped
			// Finally, place the name of the item into the equipment slot
			equipSlot[EquipSlot.Flashlight] = global.invItem[_slot][0];
			break;
		case AMULET: // Equips an amulet with a unique effect to one of two available slots
		
			// TODO -- Add equipping amulet logic here
			
			break;
		default: // No item could be equipped because an invalid slot ID was provided
			_itemEquipped = false;
			break;
	}
	
	// If the item was successfully equipped; let the inventory know that's the case.
	if (_itemEquipped) {global.invItem[_slot][3] = true;}
	
	return _itemEquipped;
}

/// @description Unequips the item from a player's equipment slot based on the item's type. If the type
/// passed in wasn't a valid piece of equipment, nothing will occur and the function will return false.
/// @param slot
/// @param itemType
function player_unequip_item(_slot, _itemType){
	// If an invalid slot value was given, don't attempt to uneuip the item
	if (_slot < 0 || _slot >= array_length(global.invItem)){
		return false;
	}
	
	// This flag is set to false if the supplied item was successfully unequipped.
	var _itemUnequipped = true;
	
	switch(_itemType){
		case WEAPON: // Unequipping the current weapon; resetting all stats back to 0
		case WEAPON_INF:
			// Reset all of the weapon's stat values back to 0; the slot is set to -1, since 0 is
			// a valid slot within the inventory
			weaponSlot =   -1;
			damage =		0;
			numBullets =	0;
			range =			0;
			accuracy =		0;
			fireRate =		0;
			reloadRate =	0;
			bulletSpd =		0;
			startFrame =	0;
			endFrame =		0;
			curAmmoType =	0;
			ds_list_clear(ammoTypes);
			
			// Also, reset the modification values for their respective stats
			damageMod =		0;
			rangeMod =		0;
			accuracyMod =	0;
			fireRateMod =	0;
			reloadRateMod = 0;
			
			// TODO -- Add sprite changes and other required code here.
			
			// Finally, remove the name from the equipment slot to free it
			equipSlot[EquipSlot.Weapon] = NO_ITEM;
			break;
		case ARMOR: // Resets the applied damage resistance/movement penalties
			if (_name == KEVLAR_VEST){ // Reset the move speed penalty if the player unequips a standard kevlar vest
				entity_update_max_speed(maxHspdConst * 0.35, maxVspdConst * 0.35);
			}
			damageResistance += 0.25;
			// Finally, remove the name from the equipment slot to free it
			equipSlot[EquipSlot.Weapon] = NO_ITEM;
			break;
		case LIGHT_SOURCE: // Returns the player's ambient light back to its default values
			update_light_settings(ambLight, 15, 15, 0.01, c_ltgray);
			isLightActive = false; // Always disable the light when unequipping it
			// Finally, remove the name from the equipment slot to free it
			equipSlot[EquipSlot.Flashlight] = NO_ITEM;
			break;
		case AMULET: // Removes the amulet from the second slot AND THEN the first slot; along with their effect
			
			// TODO -- Add amulet removal logic here
			
			break;
		default: // No item was unequipped because an invalid slot ID was provided
			_itemUnequipped = false;
			break;
	}
	
	// Sets the "equipped" flag of the item to false, regardless of if the item was successfully
	// unequiped or not. This is the case because it doesn't actually matter if an item that can't
	// be equipped has the flag set to false, so it's set anyway.
	global.invItem[_slot][3] = false;
	
	return _itemUnequipped;
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
	var _length = ds_list_size(ammoTypes);
	while(curAmmoType != _prevAmmoType){
		// Some ammo was found for the other ammunition type, put it in the weapon and exit the loop
		if (inventory_count(ammoTypes[| curAmmoType]) > 0){
			// Attempt to add the previous bullets to the inventory. If they can't be added to the inventory 
			// because there isn't enough space, add the remainder to an item and place it in the world.
			if (global.invItem[weaponSlot][1] > 0){
				var _remainder = inventory_add(ammoTypes[| _prevAmmoType], global.invItem[weaponSlot][1], 0);
				if (_remainder > 0) {create_item(global.playerID.x, global.playerID.y, ammoTypes[| _prevAmmoType], _remainder, 0);}
				// Also, remove all the ammunition from the weapon's current clip
				global.invItem[weaponSlot][1] = 0;
			}
			// Finally, fetch the ammo's modification stats and apply them to their respective stats
			if (!is_undefined(global.itemData[? AMMO_DATA][? ammoTypes[| curAmmoType]])){
				var _data = global.itemData[? AMMO_DATA][? ammoTypes[| curAmmoType]];
				damageMod =		_data[? DAMAGE_MOD];
				rangeMod =		_data[? RANGE_MOD];
				accuracyMod =	_data[? ACCURACY_MOD];
				fireRateMod =	_data[? FIRE_RATE_MOD];
				reloadRateMod = _data[? RELOAD_RATE_MOD];
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
	// Handling weapon durability if it is toggled for the selected difficulty setting
	if (global.gameplay.weaponDurability){
		if (global.invItem[weaponSlot][2] == 0){
			return false; // The weapon is broken and cannot be used anymore
		}
		// If there is still some weapon durability left, subtract one from the total
		global.invItem[weaponSlot][2]--;
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
		_weaponData = [damage + damageMod, range + rangeMod, bulletSpd];
		// Pull all the necessary data in from the weapon to the projectile, which basically means
		// the range and damage of the bullet.
		with(_object){
			// Pull in the weapon's damage and movement speed (Relative to its direction)
			damage =	_weaponData[0];
			range =		_weaponData[1];
			hspd =		lengthdir_x(_weaponData[2], _direction);
			vspd =		lengthdir_y(_weaponData[2], _direction);
			// Set the variables that track the distance the bullet has travelled relative to its max range
			startX =	x;
			startY =	y;
			// Next, set the state to handle the projectile movement for the weapon
			set_cur_state(player_attack_state_projectile);
			image_angle = _direction;
		}
	}
	// Finally, subtract one from the weapon's current magazine amount if it consumes ammo
	if (_useAmmo) {global.invItem[weaponSlot][1]--;}
	// Return that the weapon was successfully used by the player
	return true;
}

/// @description Reloads the player's currently equipped weapon. It does so by calculating the space for
/// ammunition remaining within the gun's magazine and then attempts to remove that amount from the ammo
/// found in the inventory. Finally, it takes the remainder that couldn't be pulled from the inventory and
/// subtracts that from the maximum magazine size.
/// @param clipRemainder
function player_reload_weapon(_clipRemainder){
	var _maxQuantity, _remainder;
	_maxQuantity = global.itemData[? ITEM_LIST][? global.invItem[weaponSlot][0]][? MAX_STACK];
	_remainder = inventory_remove(ammoTypes[| curAmmoType], _maxQuantity - _clipRemainder);
	global.invItem[weaponSlot][1] = _maxQuantity - _remainder;
}