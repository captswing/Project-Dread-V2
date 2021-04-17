/// @description Saves the player's game data into an encrypted file relative to the save file it was saved into. This file's
/// slot will be shown in the extension for the file itself. (Ex. All are named "data.xxx" where xxx is a three-digit number
/// that can range from "001" to "999."
/// @param saveNum
function save_game_data(_saveNum){
	// Create the temporary map that will hold all the save data that is written into the file in a JSON format.
	var _map = ds_map_create();
	
	// First, add all the global data into the save file, which includes the current room's index, total playtime,
	// and the camera's current position.
	ds_map_add(_map, "current_room", room);
	ds_map_add(_map, "total_playtime", global.totalPlaytime);
	with(global.singletonID[? CONTROLLER]){ // Store the current position of the camera
		ds_map_add(_map, "camera_x", x);
		ds_map_add(_map, "camera_y", y);
	}
	
	// Add the current world item data map to the save data, which includes all the items that haven't been picked
	// up by the player yet, and the items that have been dropped by the player, which remain in the world until
	// the player picks them up again.
	var _worldItemMap, _itemDataMap, _key1, _key2;
	_worldItemMap = ds_map_create();
	_key1 = ds_map_find_first(global.worldItemData);
	while(!is_undefined(_key1)){
		_itemDataMap = ds_map_create();
		_key2 = ds_map_find_first(global.worldItemData[? _key1]);
		while(!is_undefined(_key2)){
			ds_map_add(_itemDataMap, _key2, global.worldItemData[? _key1][? _key2]);
			_key2 = ds_map_find_next(global.worldItemData[? _key1], _key2);
		}
		ds_map_add_map(_worldItemMap, _key1, _itemDataMap);
		_key1 = ds_map_find_next(global.worldItemData, _key1);
	}
	ds_map_add_map(_map, "world_item_data", _worldItemMap);
	
	// Only the current gameplay difficulty and puzzle difficulty values need to be saved; not the entire struct
	// that contains these values and the other gameplay flags and modifiers. This is because reloading using just
	// these two values will yield the same result as saving and loading all the data, and it saves spaces in the file.
	ds_map_add(_map, "gameplay_difficulty", global.gameplay.gameplayDifficulty);
	ds_map_add(_map, "puzzle_difficulty", global.gameplay.puzzleDifficulty);
	
	// Create a map to save all the items currently found within the player's inventory. This will save the item's data
	// as ds_lists inside of this ds_map once it is loaded back in, so a conversion from ds_list to array must be used.
	// Also, save the current size of the player's inventory so that can be reloaded to the accurate value.
	var _itemMap = ds_map_create();
	for (var i = 0; i < global.invSize; i++){
		if (global.invItem[i][0] == NO_ITEM) {continue;}
		ds_map_add(_itemMap, string(i), global.invItem[i]);
	}
	ds_map_add_map(_map, "inventory_contents", _itemMap);
	ds_map_add(_map, "inventory_size", global.invSize);
	
	// Save all the event flags into a map relating to each flags state. This map is then saved into the overall map
	// before its encoded as a JSON and saved into its respective file.
	var _eventMap, _length;
	_eventMap = ds_map_create();
	_length = array_length(global.eventFlags);
	for (var i = 0; i < _length; i++) {ds_map_add(_eventMap, string(i), global.eventFlags[i]);}
	ds_map_add_map(_map, "event_flags", _eventMap);
	
	// 
	var _playerMap = ds_map_create();
	with(global.singletonID[? PLAYER]){
		ds_map_add(_playerMap, "x", x);
		ds_map_add(_playerMap, "y", y);
		ds_map_add(_playerMap, "direction", direction);
	}
	ds_map_add_map(_map, "player_data", _playerMap);
	
	// After loading all of the necessary data that will be saved into the map, save that map as a JSON encoded string
	// in a file unique to the save slot that was selected. The number for the save slot is reflected in the file's
	// extensions, which is a 3-digit number ranging from "001" to "999."
	var _filename, _file;
	_filename = "data." + number_format(_saveNum, "000");
	var _file = file_text_open_write(_filename);
	file_text_write_string(_file, json_encode(_map));
	file_text_close(_file);
	// Make sure to encrypt and replace the previous file to prevent any tampering with saved data.
	file_fast_crypt_ultra_zlib(_filename, _filename, true, "8y/B?E(H+MbQeThWmZq4t7w9z$C&F)J@NcRfUjXn2r5u8x/A%D*G-KaPdSgVkYp3");
	
	// Finally, destroy the map that was used to save all the data to the save file. Since it was used in tandem with "json_encode",
	// only the top layer of the map needs to be destroyed in order for the entire map and all its inner layers to be freed.
	ds_map_destroy(_map);
}

/// @description
/// @param saveNum
function load_game_data(_saveNum){
	// Before trying to load in the file, make sure it actually exists otherwise a crash will occur.
	var _filename = "data." + number_format(_saveNum, "000");
	if (!file_exists(_filename)) {return;}
	
	// Also, before loading in the world item data, clear out the world item data ds_map if it still somehow
	// exists and create a fresh and empty map in its place. This will prevent any potential memory leaks.
	if (ds_exists(global.worldItemData, ds_type_map)) {clear_world_item_data();}
	global.worldItemData = ds_map_create();
	
	// Make sure to decrypt the file's contents before attempting to read from it. Otherwise, all that will
	// be read in is junk data and the game will crash.
	var _decryptedFilename = "data_DECRYPTED.000";
	file_fast_crypt_ultra_zlib(_filename, _decryptedFilename, false, "8y/B?E(H+MbQeThWmZq4t7w9z$C&F)J@NcRfUjXn2r5u8x/A%D*G-KaPdSgVkYp3");
	
	// After ensuring the file exists and there are no memory leaks to be had, load in the file and decode
	// the JSON data, which will return a ds_map containing inner maps and lists that data will be read from.
	var _file, _map;
	_file = file_text_open_read(_decryptedFilename);
	file_delete(_decryptedFilename); // Delete the file from disk as soon as it's read into memory
	_map = json_decode(file_text_read_string(_file));
	file_text_close(_file);

	// Load in the general global data from the save file; warping to the room index found in the file, getting
	// the current playtime and setting its respective string value in the "HH:MM:SS" format. Then, set the
	// position of the camera to its saved position.
	room_goto(_map[? "current_room"]);
	global.totalPlaytime = _map[? "total_playtime"];
	global.playtimeString = number_as_time(global.totalPlaytime);
	with(global.singletonID[? CONTROLLER]){ // Sets the camera to the correct position
		x = _map[? "camera_x"];
		y = _map[? "camera_y"];
	}

	// Copy the world item data from the file into the empty global.worldItemData, which will correctly place
	// the dynamically dropped items from the player throughout the course of their game in the correct room.
	var _itemDataMap, _key1, _key2;
	_key1 = ds_map_find_first(_map[? "world_item_data"]);
	while(!is_undefined(_key1)){
		_itemDataMap = ds_map_create();
		_key2 = ds_map_find_first(_map[? "world_item_data"][? _key1]);
		while(!is_undefined(_key2)){
			ds_map_add(_itemDataMap, _key2, _map[? "world_item_data"][? _key1][? _key2]);
			_key2 = ds_map_find_next(_map[? "world_item_data"][? _key1], _key2);
		}
		ds_map_add_map(global.worldItemData, _key1, _itemDataMap);
		_key1 = ds_map_find_next(_map[? "world_item_data"], _key1);
	}
	
	// Initialize the difficulty with the gameplay difficulty and puzzle difficulty that was saved. This will
	// set all the gameplay modifiers and flags to what they are supposed to be.
	initialize_difficulty(_map[? "gameplay_difficulty"], _map[? "puzzle_difficulty"]);
	
	// Add the inventory contents back into the inventory array; converting the list that had to be used to save
	// the data back into an array that it then placed into each slot of the inventory. Empty slots are ignored
	// since they aren't saved either. Also set the number of available inventory slots currently available to
	// them from picking up item pouches.
	var _itemData = -1;
	for (var i = 0; i < global.invSize; i++){
		_itemData = _map[? "inventory_contents"][? string(i)];
		if (is_undefined(_itemData)) {continue;} // Skip over empty slots since those aren't saved
		global.invItem[i] = ds_list_to_array(_itemData);
	}
	global.invSize = _map[? "inventory_size"];
	
	// Load in all the event flags from the save file. These are saved as a ds_map and must be converted into
	// an array before copying that array over into the global.eventFlags variable. Otherwise, crashes will happen
	// when event flags are referenced in-game.
	var _length = ds_map_size(_map[? "event_flags"]);
	for (var i = 0; i < _length; i++) {global.eventFlags[i] = _map[? "event_flags"][? string(i)];}
	
	// 
	var _playerMap = _map[? "player_data"];
	instance_create_depth(0, 0, ENTITY_DEPTH, obj_player);
	with(global.singletonID[? PLAYER]){
		x = _playerMap[? "x"];
		y = _playerMap[? "y"];
		direction = _playerMap[? "direction"];
	}
	set_camera_cur_object(global.singletonID[? PLAYER], 0, false);
	
	// Finally, destroy the map that was used to save all the data to the save file. Since it was used in tandem with "json_decode",
	// only the top layer of the map needs to be destroyed in order for the entire map and all its inner layers to be freed.
	ds_map_destroy(_map);
}