/// @description Attempts to add the inventory at the nearest available slot to the beginning of the inventory.
/// If the entire quantity cannot be added to the inventory, the world item data will be updated to reflect
/// the remainder of that item for the player's save data.
function collect_item(){
	var _num = inventory_add(global.worldItemData[? keyIndex][? NAME], global.worldItemData[? keyIndex][? QUANTITY], global.worldItemData[? keyIndex][? DURABILITY]);
	if (_num <= 0){ // Remove the data from the item list map
		ds_map_delete(global.worldItemData, keyIndex);
		instance_destroy(self);
		return;
	}
	// Update the quantity of items remaining
	global.worldItemData[? keyIndex][? QUANTITY] = _num;
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