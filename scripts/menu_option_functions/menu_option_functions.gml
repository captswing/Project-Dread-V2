/// @description Adds an option to the list of currently existing menu options for a given menu. It will store
/// struct data that holds the option's name, it's information that tells teh player what the menu option does,
/// and the flag that can activate/deactivate the option as needed.
/// @param index
/// @param name
/// @param info
/// @param isActive
function menu_option_add(_index, _name, _info, _isActive){
	var _data = {
		// The three main variables that store the option itself, the info text that goes along with it and 
		// whether or not it can be selected by the player when they are highlighting said option.
		option : _name,
		info : string_split_lines(_info, infoMaxWidth, infoFont),
		isActive : _isActive,
		
		// A few more optional variables that can allow an individual option to be moved around the screen
		// relative to an offset from the menu's option position. This target offset is set and store within
		// each individual option struct.
		curOffsetX : 0,
		curOffsetY : 0,
		targetOffsetX : 0,
		targetOffsetY : 0,
	}
	
	// Add the option's data into the data structure based on what value was provided to the function. If any
	// value below 0 was provided, the option will be placed at the end of the option list, otherwise it will
	// be inserted to the desired index in the list.
	if (_index < 0){ds_list_add(option, _data);}
	else {ds_list_insert(option, clamp(_index, 0, numOptions - 1), _data);}
	numOptions++; // Increment the variable storing the total number of options to reflect the addition.
	
	// Finally, set the amount of rows in the menu relative to the current number of options and the menu's 
	// currently set width.
	menuDimensions[Y] = ceil(numOptions / menuDimensions[X]);
}

/// @description Deletes a menu option's struct data from the index provided. This removes both the option
/// and its information text automatically, so nothing else needs to be done to avoid weird out-of-order
/// errors between the options and option information.
/// @param index
function menu_option_delete(_index){
	// An out of range index was provided; don't attempt to delete from the index
	if (_index < 0 && _index >= numOptions) {return;}
	
	// Delete the struct that exists within the list at the given index before moving the pointer to that
	// struct from the list itself; otherwise the pointer is lost and a memory leak will occur.
	delete option[| _index];
	ds_list_delete(option, _index);
	numOptions--; // Decrement the variable storing the total number of options to reflect the deletion.
}

/// @description A simple function that just clears out the current option data from the list. Useful for
/// "switching" menus when multiple sections of said menu are handled by the same object. (Ex. Inventory)
function menu_option_clear(){
	// Loop and delete the 0th option from the list until it is empty
	while(numOptions > 0){
		delete option[| 0];
		ds_list_delete(option, 0);
		numOptions--;
	}
}

/// @description Simply sets the active flag for the option at the provided index to either true or false.
/// The flag being flase will prevent the player from selecting the option and thus prevent it from running
/// any of the code it will do upon selection.
/// @param index
/// @param isActive
function menu_option_set_active(_index, _isActive){
	// An out of range index was provided; don't attempt to change the non-existent active state
	if (_index < 0 && _index >= numOptions) {return;}
	
	// Set the active flag for the option to whatever the provided to the function
	with(option[| _index]) {isActive = _isActive;}
}

/// @description Takes in the index for the option that will be dealt with, and then the target position on
/// the screen relative to its current position that it will be moved to over a couple of the next frames.
/// @param index
/// @param targetX
/// @param targetY
function menu_option_set_target_position(_index, _targetX, _targetY){
	// An out of range index was provided; don't attempt to set the non-existent option's target position
	if (_index < 0 && _index >= numOptions) {return;}
	
	// Set the target position variables to what was provided to the function's arguments
	with(option[| _index]){
		targetOffsetX = _targetX;
		targetOffsetY = _targetY;
	}
}

/// @description A function that's sole purpose is to reset the current option's target position values with
/// the position (0, 0); returning it to its initial offset position relative to the menu's position for the
/// options and the offset based on the option's index in the list.
/// @param index
function menu_option_reset_target_position(_index){
	// An out of range index was provided; don't attempt to reset the non-existent option's target position
	if (_index < 0 && _index >= numOptions) {return;}
	
	// Simply reset both variables back to zero, and the option will move to the position
	with(option[| _index]){
		targetOffsetX = 0;
		targetOffsetY = 0;
	}
}

/// @description 
/// @param curOption
function menu_option_set_cur_option(_curOption){
	curOption = max(_curOption, 0);
	// Optionally, after setting the menu cursor, reset all the typewriter effect variables to compensate 
	// for the newly highlighted option's information text.
	if (curOption < numOptions && scrollingInfoText){
		visibleText = "";
		nextCharacter = 0;
		// If the option is active it will use its own info text, otherwise the default inactive text is used.
		finalCharacter = option[| curOption].isActive ? string_length(option[| curOption].info) : infoInactiveTextLength;
	}
}