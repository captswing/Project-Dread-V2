/// @description Adds a new struct containing control information to the list of existing control data. It 
/// holds all the information necessary for the player to know what key needs to be pressed in order to 
/// perform a given action.
/// @param key
/// @param anchor
/// @param info
/// @param calculatePositions
function control_info_add_control_data(_key, _anchor, _info, _calculatePositions){
	// A struct holding all the information for the keybinding information. The key's icon, text describing
	// what the control does in context of the game; the position of the text and its sprite, respectively; 
	// and the anchor it uses. (can be either a right-side anchor or a left-side anchor)
	var _controlData = {
		// The key value that points to the icon data for the control keybinding in the global ds_map
		iconKey :		_key,
		// Position of the text and sprite information on the screen. Calculated relative to the anchor
		textPos :		[0, 0],
		sprPos :		[0, 0],
		// The starting position for the control data's position. It's offset relative to the order it is
		// found in within the other control data that uses the same anchor.
		anchor :		_anchor,
		// The text that displays next to the control data's icon to describe what the control binding does
		infoText :		_info,
	}
	ds_list_add(controlData, _controlData);
	
	// When the flag to calculate the positions for all the control data information relative to the current
	// anchor is set, this will call the function that handles said calculations.
	if (_calculatePositions) {control_info_calculate_positions(_anchor);}
}

/// @description Removes the information for the controls that are found at the given index in the ds_list
/// of control data. After that, it will re-calculate the positions of control data that shares the same anchor.
/// @param index
function control_info_remove_control_data(_index){
	// Prevent the function from removing any data from invalid indexes in the ds_list
	if (_index < 0 || _index >= ds_list_size(controlData)) {return;}
	
	// Store the anchor the control data used for later use
	var _anchor = controlData[| _index].anchor;
	
	// Deletes the struct containing the control data from memory before removing its pointer from the list
	delete controlData[| _index];
	ds_list_delete(controlData, _index);
	
	// Re-calculates the positions of controls sharing the same anchor to compensate for the data removal
	control_info_calculate_positions(_anchor);
}

/// @description Clears out all of the control information that current exists in the control data ds_list.
/// This is useful for when a complete refresh of the controls is necessary; like when the player switches
/// between two different menus, for example.
function control_info_clear_all(){
	var _length = ds_list_size(controlData);
	for (var i = 0; i < _length; i++) {delete controlData[| i];}
	ds_list_clear(controlData);
}

/// @description Calculates the positions of the control data relative to the anchor that is provided in the
/// argument section. It goes from the earliest control data found to use this anchor to the last to use this
/// anchor in the list, so that is important for knowing how to order the controls for each anchor. 
/// @param index
function control_info_calculate_positions(_anchor){
	// Creates an array at position (0, 0) that will store the relative anchor position if the correct value
	// was placed into the argument space. If an incorrect value was provided, the position of (0, 0) will 
	// be used as a default.
	var _anchorPos = [0, 0];
	if (_anchor == LEFT_ANCHOR) {_anchorPos = leftAnchor;}
	else if (_anchor == RIGHT_ANCHOR) {_anchorPos = rightAnchor;}
	
	// Sets the font in order to accurately calculate the string width for all information text.
	draw_set_font(font_gui_small);
	
	// Loop through the entire list of control data; skipping over the data that doesn't use the current
	// anchor value. The data that uses the current anchor will have its positions accurately calculated
	// relative to its position in the rest of the data, which goes from first to last for the offsets.
	var _length, _offset;
	_length = ds_list_size(controlData);
	_offset = 0;
	for (var i = 0; i < _length; i++){
		with(controlData[| i]){
			// The anchor doesn't match what's in the argument space, skip the control data at the index
			if (anchor != _anchor) {continue;}
			
			// Calcuates the sprite position relative to the current stored offset position, which will
			// move the positions more to the left for the right anchor, and the right for the left anchor.
			// The width of the sprite plus a bit of a buffer gets added to the offset for later use.
			sprPos = [_anchorPos[X] + (_offset * -_anchor), _anchorPos[Y] - 2];
			_offset += sprite_get_width(global.controlIcons[? iconKey][0]) + 2;
			
			// If info text exists for this control data, the text position will be calculated in the exact
			// same fashion as the sprite position; with the offset and all that stuff. Like the sprite 
			// position, the text's width is added to the offset plus a slightly larger buffer.
			if (infoText != ""){
				textPos = [_anchorPos[X] + (_offset * -_anchor), _anchorPos[Y]];
				_offset += string_width(infoText) + 6;
			}
		}
	}
}