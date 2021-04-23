/// @description Attempts to add the inventory at the nearest available slot to the beginning of the inventory.
/// If the entire quantity cannot be added to the inventory, the world item data will be updated to reflect
/// the remainder of that item for the player's save data.
function collect_item(){
	var _name, _num;
	_name = global.worldItemData[? keyIndex][? NAME];
	_num = inventory_add(_name, global.worldItemData[? keyIndex][? QUANTITY], global.worldItemData[? keyIndex][? DURABILITY]);
	// Pop up a textbox letting the player know what item they've collected; if they've even collected one
	if (_num == global.worldItemData[? keyIndex][? QUANTITY]){ // No inventory space
		create_textbox("Your inventory is full...");
	} else if (_num > 0){ // The inventory has space, but not enough for the full quantity
		create_textbox("Picked up only " + string(global.worldItemData[? keyIndex][? QUANTITY] - _num) + " of the " + string(global.worldItemData[? keyIndex][? QUANTITY]) + " " + _name + ". The inventory is full and cannot fit the rest, so it was left alone.");
		play_sound_effect(snd_item_pickup, get_audio_group_volume(Settings.Sounds), true);
	} else{ // Inventory has space for the whole quantity, display what was picked up
		var _itemData = global.itemData[? ITEM_LIST][? _name];
		if (_itemData[? MAX_STACK] == 1 || (string_count(WEAPON, _itemData[? ITEM_TYPE]) == 1)){ // The item isn't stackable or is a weapon, don't show the quantity
			create_textbox("Picked up " + _name + ".");
		} else{ // The item can be stacked, show the player the quantity of what they picked up
			create_textbox("Picked up " + string(global.worldItemData[? keyIndex][? QUANTITY]) + " " + _name + ".");
		}
		play_sound_effect(snd_item_pickup, get_audio_group_volume(Settings.Sounds), true);
	}
	// Remove the data from the item list map if the entire quantity was picked up
	if (_num <= 0){
		ds_map_delete(global.worldItemData, keyIndex);
		instance_destroy(self);
		return;
	}
	// Update the quantity of items remaining if some is still left over
	global.worldItemData[? keyIndex][? QUANTITY] = _num;
}

/// @description A unique case where the player picks up the "Item Pouch" which increases the inventory's
/// size by 2 spaces -- to a maximum relative to the current difficulty settings, which ranges between 24
/// and 10 available inventory slots.
function collect_inventory_expansion(){
	// Increase the current slot size by 2 if the maximum size has yet to be reached
	if (global.invSize < global.maxInvSize){
		create_textbox("Item pouch acquired! Maximum inventory space has been increased!");
		global.invSize += 2;
	}
	play_sound_effect(snd_item_pickup, get_audio_group_volume(Settings.Sounds), true);
	// Finally, delete the "Item Pouch" from the world item data, as it's been successfully collected
	ds_map_delete(global.worldItemData, keyIndex);
	instance_destroy(self);
}

/// @description Creates an item on the floor at a given location. However, since this item didn't come from
/// the world_item_data.json file, it has to have additional data within the map to tell the game where to
/// spawn this object and in what room. This allows items to be persistent much like Resident Evil: Zero.
/// @param x
/// @param y
/// @param name
/// @param quantity
/// @param durability
function create_item(_x, _y, _name, _quantity, _durability){
	var _mapData = ds_map_create();
	// Add the data to the map that is required for adding the item to the world
	ds_map_add(_mapData, NAME, _name);
	ds_map_add(_mapData, QUANTITY, _quantity);
	ds_map_add(_mapData, DURABILITY, _durability);
	// NOTE -- These keys and respective data only exist for items that are removed from the player's 
	// inventory and will be absent in items that already exist in the world; placed by me.
	ds_map_add(_mapData, X_POSITION, _x);
	ds_map_add(_mapData, Y_POSITION, _y);
	ds_map_add(_mapData, ROOM, room);
	// Finally, add the item's data to the ds_map and create an instance of the item at the supplied position
	var _item = instance_create_depth(_x, _y, ENTITY_DEPTH, obj_item);
	_item.keyIndex = string(ds_map_size(global.worldItemData));
	ds_map_add(global.worldItemData, _item.keyIndex, _mapData);
}