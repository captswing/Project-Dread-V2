/// @description Swaps the current active game state to another based on the argument provided. If the high
/// priority flag is not toggled, the game state won't be set if it falls below the priority of the current
/// state. Otherwise, it will overwrite regardless of the state. Finally, the previous state will be stored
/// in the previous game state variable.
/// @param newState
/// @param highPriority
function set_game_state(_newState, _highPriority){
	if (_newState == global.gameState || _newState < GameState.InGame || _newState > GameState.Paused){
		return; // An invalid OR the same game state was provided, don't change game states
	}
	// Toggling the high priority flag allows the game state to overwrite a more prioritized state. The order
	// of priority in the states is as follows: in-game, in-menu, cutscene, and finally paused.
	if (_highPriority || global.gameState < _newState){
		global.prevGameState = global.gameState;
		global.gameState = _newState;
	}
}

/// @desceription Sets an event flag at a given index to either true or false. This allows setting an event flag
/// without the risk of setting an invalid index, which could happen if not for this function.
/// @param index
/// @param flagState
function set_event_flag(_index, _flagState){
	if (_index < 0 || _index >= array_length(global.eventFlags)){
		return; // An invalid index was put into the function, don't set any flags
	}
	global.eventFlags[_index] = _flagState;
}

/// @description Gets the state of the event flag at the provided index. However, if an invalid state was provided
/// to the function it will return false no matter what the flag it was looking for should be.
/// @param index
function get_event_flag(_index){
	if (_index < 0 || _index >= array_length(global.eventFlags)){
		return false; // An invalid index was put into the function, return false
	}
	return global.eventFlags[_index];
}

/// @description Attempts to add the object into a one of the many singleton key/value pairs. If the object
/// can't be a singleton to begin with or another singleton of this object already exists, the function will
/// return false. Otherwise, the singleton will gain the current object's id and it will become a singleton.
function add_singleton_object(){
	// First, check if this object can even be a singleton in the first place
	var _key = is_valid_singleton();
	if (_key == undefined) {return false;}
	// Check if the key already contains the object. If so, delete this duplicate. If not, simply add the
	// object's ID into the singleton key/value pair; making it the singleton's object.
	if (instance_exists(global.singletonID[? _key])){
		instance_destroy(self);
		return false;
	}
	ds_map_set(global.singletonID, _key, id);
	return true;
}

/// @description Removes the id value from a given singleton object. If the key cannot be found out of
/// all the valid singleton object indexes, then nothing will happen to any singleton value.
function remove_singleton_object(){
	var _key = is_valid_singleton();
	if (_key != undefined) {ds_map_set(global.singletonID, _key, noone);}
}

/// @description Checks the given object index with a switch statements filled with valid singleton object
/// indexes. If the object matches an index found in the statement, the key will be returned. Otherwise, the
/// function will return undefined and the object is not a singleton.
function is_valid_singleton(){
	switch(object_index){
		case obj_controller:		return CONTROLLER;
		case obj_effect_handler:	return EFFECT_HANDLER;
		case obj_depth_sorter:		return DEPTH_SORTER;
		case obj_textbox:			return TEXTBOX;
		case obj_cutscene:			return CUTSCENE;
		case obj_player:			return PLAYER;
		default:					return undefined;
	}
}