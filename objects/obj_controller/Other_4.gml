/// @description Enable the Current Room's View/Update Entity Stuff/Check For Items That Should Spawn

if (cameraID != -1){ // Only enable the view if a valid camera object exists
	view_enabled = true;
	view_camera[0] = cameraID;
	view_set_visible(0, true);
}

// Gets the footstep sound tile layer for the current room
with(par_dynamic_entity) {collisionTilemap = layer_tilemap_get_id(layer_get_id("Footstep_Tiles"));}

// Next, loop through the dynamically dropped items to see if they need to be created in this room.
var _length, _key, _data, _item;
_length = ds_list_size(global.dynamicItemKeys);
for (var i = 0; i < _length; i++){
	_key = string(global.dynamicItemKeys[| i]);
	_data = ds_map_find_value(global.worldItemData, _key);
	if (!is_undefined(_data)){
		if (_data[? ROOM] == room){ // The room indexes match; spawn the item
			_item = instance_create_depth(_data[? X_POSITION], _data[? Y_POSITION], ENTITY_DEPTH, obj_item);
			_item.keyIndex = _key;
		}
		continue;
	}
	// The list holds an invalid map key for some reason, delete it from the list
	ds_list_delete(global.dynamicItemKeys, i);
	_length--; // Subtract both values by one to compensate for the index removal
	i--; 
}

// Disable visibility of collision layer if debug mode isn't enabled
layer_set_visible(layer_get_id("Collision"), showDebugInfo);