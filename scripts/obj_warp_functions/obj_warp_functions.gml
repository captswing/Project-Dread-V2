/// @description
function warp_state_warping(){
	// Checks every frame for the effect handler's fade to see if it's begun its fade out, which will trigger
	// the actual code that warps the player to the next room, relative to the _warpSuccess flag.
	var _warpSuccess = false;
	with(global.singletonID[? EFFECT_HANDLER]){
		if (fade != noone && fade.fadingOut){
			_warpSuccess = true;
		}
	}
	
	// When the _warpSuccess flag is triggered, the fade has been opaque for the necessary amount of time and
	// the warp will actually occur; along with the sound effect that was set for the door's closing.
	if (_warpSuccess){
		set_cur_state(NO_STATE); // Prevents another warp from occurring
		play_sound_effect(doorCloseSound, 1, false);
		warp_to_room(global.singletonID[? PLAYER], targetX, targetY, targetRoom);
	}
}

/// @description 
function interact_room_warp(){
	// Checks through all the required keys to see if the player's doesn't have one of them; in which case
	// the warp to the next room will not occur, and a textbox message will pop up letting the player know
	// they don't have all the required keys.
	var _length = ds_list_size(requiredKeys);
	if (_length > 0){ // Only loop if there are keys to loop and check for.
		for (var i = 0; i < _length; i++){
			if (inventory_count(requiredKeys[| i]) < 1){ // Key is missing; let player know.
				if (_length > 1) {create_textbox("The door is locked... Looks like I need " + string(_length) + " keys to unlock it.");}
				else {create_textbox("The door is locked... I should look for its key.");}
				play_sound_effect(doorLockedSound, 1, false);
				return; // Exits out of the loop and script early
			}
		}
		// Remove the keys from the inventory after they've been used, since they're no longer needed.
		var _textboxString = "";
		for (var i = 0; i < _length; i++){
			inventory_remove(requiredKeys[| i], 1);
			// Add a comma or "and" before each key name if there was more than one key used
			if (_length > 1 && i != 0){
				if (i == _length - 1) {_textboxString += " and ";}
				else {_textboxString += ", ";}
			}
			_textboxString += requiredKeys[| i];
		}
		create_textbox("Used the " + _textboxString + " to open the door.");
		// Clear out the warp's ds_list, which turns this into a truly open door, and set its event flag.
		set_event_flag(eventFlagIndex, true);
		ds_list_clear(requiredKeys);
		return; // Exits before the warp actually happens.
	}
	// The check for the required keys has passed OR there wasn't a check needed to begin with, since the 
	// door is unlocked by default. Begins the fade that will result in the door warp being triggered.
	var _opaqueTime = (audio_sound_length(doorOpenSound) + 0.5) * 60;
	with(global.singletonID[? EFFECT_HANDLER]) {create_screen_fade(c_black, 0.05, _opaqueTime);}
	set_cur_state(warp_state_warping);
}

/// @description
/// @param warpedObject
/// @param x
/// @param y
/// @param room
function warp_to_room(_warpedObject, _x, _y, _room){
	// A warp won't occur if the object to warp isn't valid or if the room index isn't valid
	if (_warpedObject != noone && room_exists(_room)){
		room_goto(_room);
		with(_warpedObject){ // Warp's the object to the correct position in the new room
			x = _x;
			y = _y;
		}
	}
}