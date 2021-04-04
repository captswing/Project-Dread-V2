/// @description Initializes the inventory array with a unique size that is dependent on the player's chosen
/// difficulty setting. Can also be used to reset said inventory array when loading data from another file
/// or starting a new game entirely.
/// @param difficulty
function inventory_initialize(_difficulty){
	// Gets the starting inventory capacity and maximum possible size relative to the player's current
	// difficulty setting; as each difficulty has a unique starting and maximum inventory size.
	switch(_difficulty){
		case Difficulty.Forgiving:
			global.invSize = 12;
			global.maxInvSize = 24;
			break;
		case Difficulty.Standard:
			global.invSize = 8;
			global.maxInvSize = 20;
			break;
		case Difficulty.Punishing:
			global.invSize = 8;
			global.maxInvSize = 16;
			break;
		case Difficulty.Nightmare:
			global.invSize = 6;
			global.maxInvSize = 12;
			break;
		case Difficulty.OneLifeMode:
			global.invSize = 6;
			global.maxInvSize = 10;
			break;
	}
	
	// Finally, after getting the maximum possible size for the inventory relative to the selected difficulty,
	// initialize the array that contains the item information relative to the set maximum size.
	for (var i = 0; i < global.maxInvSize; i++){
		global.invItem[i][0] = NO_ITEM;	// The item's key within the item data map
		global.invItem[i][1] = 0;		// Total number of items currently in the slot
		global.invItem[i][2] = 0;		// The item's durability (Nightmare and One Life Mode only)
		global.invItem[i][3] = false;	// A flag storing if the item is equipped to the player or not
	}
}

/// @description Attempts the add the desire quantity from the player's inventory. It does so by sifting
/// through said inventory; looking for empty slots or slots of the same item with space for more items. Then,
/// it adds the item to those slots and returns whatever couldn't be added to the inventory.
/// @param name
/// @param quantity
/// @param durability
function inventory_add(_name, _quantity, _durability){
	var _maxQuantity, _isWeapon;
	_maxQuantity = global.itemData[? ITEM_LIST][? _name][? MAX_STACK];
	_isWeapon = (string_count(WEAPON, global.itemData[? ITEM_LIST][? _name][? ITEM_TYPE]) == 1);
	
	// Loop through the entire inventory looking for slots of existing items this one can fit into, or
	// for an empty slot that it can be added to (Ex. weapons can't be stacked despite having a maxQuantity
	// greater than one).
	for (var i = 0; i < global.invSize; i++){
		if (!_isWeapon && _maxQuantity > 1 && global.invItem[i][1] < _maxQuantity && (global.invItem[i][0] == _name || global.invItem[i][0] == NO_ITEM)){
			global.invItem[i][0] = _name;
			if (global.invItem[i][1] + _quantity <= _maxQuantity){ // Enough room in current slot; add entire quantity to said slot
				global.invItem[i][1] += _quantity;
				return 0; // The item and its entire quantity was added to the inventory; return 0
			} else{ // Not enough room in current slot; add as much as possible to it and move on.
				_quantity -= _maxQuantity - global.invItem[i][1];
				global.invItem[i][1] = _maxQuantity;
			}
		} else if (global.invItem[i][0] == NO_ITEM){ // The item isn't stackable or is a weapon; add it to an empty slot and move along
			global.invItem[i][0] = _name;
			global.invItem[i][1] = min(_quantity, _maxQuantity);
			// Only bother editing the durability value of the item if it's a weapon
			if (_isWeapon){
				var _maxDurability = global.itemData[? WEAPON_DATA][? _name][? DURABILITY];
				global.invItem[i][2] = min(_durability, _maxDurability);
			}
			return 0; // The item was added to the inventory successfully; return 0
		}
	}
	
	// Finally, return the remaining amount back to the item for it to update the world item data
	return _quantity;
}

/// @description Removes the required sum of the specified item from the inventory by looping through the
/// currently available inventory space; looking for said item(s) and removing them as they're found. If
/// not all the required items could be removed, the remaining quantity will be returned. Otherwise, a zero
/// will be returned by the function to indicate the successful removal of the item(s).
/// @param name
/// @param quantity
function inventory_remove(_name, _quantity){
	var _maxQuantity, _isWeapon;
	_maxQuantity = global.itemData[? ITEM_LIST][? _name][? MAX_STACK];
	_isWeapon = (string_count(WEAPON, global.itemData[? ITEM_LIST][? _name][? ITEM_TYPE]) == 1);
	
	// Loop through the entire inventory looking for the item specified in order to remove it. The quantity
	// is returned after looping through the whole inventory if the amount needed for deletion cannot be
	// satisfied by the current contents in the inventory.
	for (var i = global.invSize - 1; i >= 0; i--){
		// The item in the slot matches the name the inventory is looking for; try to remove it
		if (global.invItem[i][0] == _name){
			if (_maxQuantity == 1 || _isWeapon){ // Treat weapons as a single item instead of multiple
				global.invItem[i] = [NO_ITEM, 0, 0, false];
				_quantity--;
			} else{ // Treat every other stackable item as normal
				if (global.invItem[i][1] > _quantity){ // More items exist than need to be removed from the slot
					global.invItem[i][1] -= _quantity;
					return 0; // Enough items were removed to satisfy the quantity; return 0
				} else{ // Remove the entire stack and continue through searching through the inventory
					_quantity -= global.invItem[i][1];
					global.invItem[i] = [NO_ITEM, 0, 0, false];
				}
			}
		}
		// There are no more items to remove from the inventory; break out of the loop early.
		if (_quantity == 0) {break;}
	}
	
	// Finally, return whatever quantity remains left over that wasn't removed
	return _quantity;
}

/// @description Removes the entire quantity of an item from the desired slot. Optionally, an item containing
/// that slot's data can be created at the desired position, which will add it to the world item data's ds_map.
/// @param slot
/// @param createItem
/// @param x
/// @param y
function inventory_remove_slot(_slot, _createItem, _x, _y){
	if (_createItem) {create_item(_x, _y, global.invItem[_slot][0], global.invItem[_slot][1], global.invItem[_slot][2]);}
	global.invItem[_slot] = [NO_ITEM, 0, 0, false];
}

/// @description Swaps the data between two different inventory slots. If the same slot is provided twice
/// the function will not execute because that would be a complete waste of CPU time.
/// @param firstSlot
/// @param secondSlot
function inventory_swap(_firstSlot, _secondSlot){
	// Same slot supplied twice, don't execute any code
	if (_firstSlot == _secondSlot) {return;}

	// Stores the data from the first slot into a temporary array
	var _tempSlot = array_create(0, 0);
	array_copy(_tempSlot, 0, global.invItem[_firstSlot], 0, 4);
	
	// After storing the first slot in a temporary array, swap the second to the first, and first to the second
	array_copy(global.invItem[_firstSlot], 0, global.invItem[_secondSlot], 0, 4);
	array_copy(global.invItem[_secondSlot], 0, _tempSlot, 0, 4);
}

/// @description Returns the total sum of the provided item that exists within the inventory at the current
/// moment in time. If the item is a weapon, however, it won't add the quantity to the total, but will instead
/// increment the count by one, since the quantity is actually the ammo currently in the gun's magazine.
/// @param name
function inventory_count(_name){
	var _count = 0;
	
	// Loop through the entire inventory, counting the total number of each item
	for(var i = 0; i < global.invSize; i++){
		if (global.invItem[i][0] == _name){
			if (string_count(WEAPON, global.itemData[? ITEM_LIST][? _name][? ITEM_TYPE]) == 1){
				_count++; // Only add one item to the count for weapons
				continue; // Move onto the next slot
			}
			// Add the total quantity of the item in the current slot
			_count += global.invItem[i][1];
		}
	}
	
	// Finally, return the sum that was calculated
	return _count;
}

/// TODO -- Move this code to another script file that contains data for the item menu as well, since this
/// code is only ever being used by the item menu in the inventory.

/// @description 
/// @param slot
function inventory_item_options(_slot){
	var _itemType, _options;
	_itemType = global.itemData[? ITEM_LIST][? global.invItem[_slot][0]][? ITEM_TYPE];
	_options = array_create(0, "");
	
	// The options available to each item will vary depending on their type. However, the options
	// "Move" and "Drop" are constant no matter what type the item is.
	switch(_itemType){
		case WEAPON:		// An item that can be equipped which consumes ammunition
			_options[0] = global.invItem[_slot][3] ? UNEQUIP_ITEM : EQUIP_ITEM;
			_options[1] = RELOAD_ITEM;
			_options[2] = MOVE_ITEM;
			_options[3] = DROP_ITEM;
			break;
		case WEAPON_INF:	// An item that doesn't consume ammo, but can be equipped
		case ARMOR:
		case LIGHT_SOURCE:
		case AMULET:
			_options[0] = global.invItem[_slot][3] ? UNEQUIP_ITEM : EQUIP_ITEM;
			_options[1] = MOVE_ITEM;
			_options[2] = DROP_ITEM;
			break;
		case COMBINABLE:	// An item that can't be consumed at all, but can be combined with another
		case AMMUNITION:
			_options[0] = COMBINE_ITEM;
			_options[1] = MOVE_ITEM;
			_options[2] = DROP_ITEM;
			break;
		case CONSUMABLE:	// An item that can be consumed or used by the player to solve puzzles, unlock doors, etc.
		case KEY_ITEM:
			_options[0] = USE_ITEM;
			_options[1] = COMBINE_ITEM;
			_options[2] = MOVE_ITEM;
			_options[3] = DROP_ITEM;
			break;
		default:			// The item doesn't have a defined type and thus has no real functions
			_options[0] = MOVE_ITEM;
			_options[1] = DROP_ITEM;
			break;
	}
	
	// Return the resulted array back to wherever this function was called from
	return _options;
}

/// @description 
/// @param slot
/// @param option
function inventory_item_options_function(_slot, _option){
	var _itemType = global.itemData[? ITEM_LIST][? global.invItem[_slot][0]][? ITEM_TYPE];
	
	// The function of the options provided by the items based on their type defined in the 
	// item_data JSON file.
	switch(_option){
		case USE_ITEM: // Using a consumable or key item
			var _itemUsed = false;
			if (_itemType == CONSUMABLE) {_itemUsed = inventory_item_use_consumable(_slot);} 
			else if (_itemType == KEY_ITEM) {/* USING A KEY ITEM -- Usually has a unique function associated with it */}
			// Only remove the item from the inventory if it was successfully used
			if (_itemUsed) {inventory_remove(global.invItem[_slot][0], 1);}
			break;
		case EQUIP_ITEM: // Equips the item to the player character
			with(global.playerID) {player_equip_item(_slot, _itemType);}
			break;
		case UNEQUIP_ITEM: // Unequips the item from the player character
			with(global.playerID) {player_unequip_item(_slot, _itemType);}
			break;
		case RELOAD_ITEM: // Reloads the player's currently equipped weapon if possible
			if (_itemType != WEAPON_INF){
				with(global.playerID){ // Jumps over to the player object to handle reloading
					if (weaponSlot == _slot && inventory_count(ammoTypes[| curAmmoType]) > 0){
						player_reload_weapon(global.invItem[weaponSlot][1]);
					}
				}
			}
			break;
		case COMBINE_ITEM:
			// TODO -- Add combination logic here
			break;
		case MOVE_ITEM:
			// TODO -- Add combination logic here
			break;
		case DROP_ITEM: // Dropping the item out of the player's inventory
			with(global.playerID) {
				// If the item was equipped by the player, unequip the item before removing the data
				if (global.invItem[_slot][3]) {player_unequip_item(_slot, _itemType);}
				inventory_remove_slot(_slot, true, x, y);
			}
			break;
	}
}

/// @description Consumes the selected item and applies its effect(s) to the player. There are seven possible
/// effects that can be applied, but not all need to be applied by each item. However, each time an item is
/// consumed it will check for all seven effects and if it needs to apply them or not.
/// @param slot
function inventory_item_use_consumable(_slot){
	var _consumableData, _itemConsumed;
	_consumableData = global.itemData[? CONSUMABLE_DATA][? global.invItem[_slot][0]];
	_itemConsumed = false;
	
	// Go through all the possible consumption effects and see which ones are triggered by the consumable.
	// It can include hitpoint/sanity gain, poison/bleeding curing, temporary damage resistance, poison
	// immunity or bleed immunity.
	with(global.playerID){
		// UNIQUE CASE -- Using the item "Revitalife" works different form other consumables. Instead of fitting
		// into the seven different possible effects for the standard consumable, this item increases the current
		// maximum health of the player -- to a maximum of 50.
		if (global.invItem[_slot][0] == REVITALIFE){
			if (maxHitpoints < 50) {set_max_hitpoints(maxHitpoints + 5, true);}
			return true; // Ignore the rest of the function
		}
		
		// Increase the player's health by a percentage value relative to their current max health
		if (_consumableData[? HITPOINT_GAIN] > 0){
			update_hitpoints(maxHitpoints * (_consumableData[? HITPOINT_GAIN] / 100));
			_itemConsumed = true; // Item was successfully consumed
		}
		
		// Increase the player's current sanity value by a percentage relative to their current maximum
		if (_consumableData[? SANITY_GAIN] > 0){
			update_sanity(maxSanity * (_consumableData[? SANITY_GAIN] / 100), true);
			_itemConsumed = true; // Item was successfully consumed
		}
		
		// Remove poisoning from the player, regardless of if they're poisoned or not, since there's no
		// way a player would want to be poisoned from consuming an item...
		if (_consumableData[? CURE_POISON]){
			set_poisoned(false);
			_itemConsumed = true;  // Item was successfully consumed
		}
		
		// Remove bleeding effect from the player, regardless of whether or not the status condition is
		// currently effecting the player or not; just like above.
		if (_consumableData[? CURE_BLEEDING]){
			set_bleeding(false);
			_itemConsumed = true;  // Item was successfully consumed
		}
		
		// Granting the player with temporary immunity from being poisoned. This timer is determined by the
		// item's consumable data itself, where 60 units of that timer equals 1 second of real-time.
		if (_consumableData[? POISON_IMMUNITY] > 0){
			add_new_effect(Effect.PoisonImmunity, _consumableData[? POISON_IMMUNITY], NO_SCRIPT, NO_SCRIPT);
			if (isPoisoned) {set_poisoned(false);} // Remove poison effect if it's currently active
			_itemConsumed = true;  // Item was successfully consumed
		}
		
		// Granting the player a temporary immunity from getting the bleeding effect. THe timer is determined
		// the same way as the poison immunity timer is right above.
		if (_consumableData[? BLEED_IMMUNITY] > 0){
			add_new_effect(Effect.BleedImmunity, _consumableData[? BLEED_IMMUNITY], NO_SCRIPT, NO_SCRIPT);
			if (isBleeding) {set_poisoned(false);} // Remove bleeding effect if it's currently active
			_itemConsumed = true;  // Item was successfully consumed
		}
		
		// Gives the player a temporary damage resistance, which cuts any incoming damage by 50% relative
		// to their current damage resistance. This means the effect is greater when the player isn't wearing
		// the kevlar vest or fortified amulet.
		if (_consumableData[? DAMAGE_RESIST] > 0){
			add_new_effect(Effect.DamageResist, _consumableData[? DAMAGE_RESIST], NO_SCRIPT, NO_SCRIPT);
			_itemConsumed = true;  // Item was successfully consumed
		}
	}
	
	// Returns whether or not the item was successfully consumed
	return _itemConsumed;
}