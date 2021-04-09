/// GAME STATE FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// EVENT FLAG FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////////

/// @desceription Sets an event flag at a given index to either true or false. This allows setting an event flag
/// without the risk of setting an invalid index, which could happen if not for this function.
/// @param index
/// @param flagState
function set_event_flag(_index, _flagState){
	 // Makes sure the flag index is within the bounds of the event flag array
	if (_index >= 0 && _index < array_length(global.eventFlags)){
		global.eventFlags[_index] = _flagState;
		return true; // The flag was successfully set
	}
	return false; // Invalid flag attampted to be set, return false
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// SINGLETON FUNCTIONS /////////////////////////////////////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// SOUND PLAYBACK FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////

/// @description Plays a sound effect at a variable volume level relative to the setting for the volume of sounds.
/// Optionally, the previous instance of the sound effect can be stopped before playing the current one to prevent
/// any odd overlapping of the same sound, which sounds horrible.
/// @param sound
/// @param volume
/// @param stopPrevious
function play_sound_effect(_sound, _volume, _stopPrevious){
	if (_stopPrevious && audio_is_playing(_sound)){
		audio_stop_sound(_sound);
	}
	// Plays the sound and sets the volume of it based on the setting and the argument provided
	var _soundID = audio_play_sound(_sound, 0, false);
	audio_sound_gain(_soundID, _volume * get_audio_group_volume(Settings.Sounds), 0);
	// Return the sound's ID value, which is provided by game maker's built-in sound functions
	return _soundID;
}

/// @description Gets the volume for a group of sounds, which is the ratio of the master volume (Ranges from 
/// 0 to 1) and the ratio of that times the respective sound volume also divided by 100 to make it a range 
/// between 0 and 1, like the master volume above.
/// @param audioGroup
function get_audio_group_volume(_audioGroup){
	var _master = global.settings[Settings.Master] / 100;

	switch(_audioGroup){
		case Settings.Music:	return global.settings[Settings.Music] * _master / 100;
		case Settings.Sounds:	return global.settings[Settings.Sounds] * _master / 100;
		default:				return _master; // No valid group provided, just return the master volume
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////