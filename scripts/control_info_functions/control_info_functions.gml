/// @description 
/// @param key
/// @param anchor
/// @param info
/// @param calculatePositions
function control_info_add_control_data(_key, _anchor, _info, _calculatePositions){
	// 
	var _controlData = {
		//
		iconKey :		_key,
		// 
		textPos :		[0, 0],
		sprPos :		[0, 0],
		// 
		anchor :		_anchor,
		// 
		infoText :		_info,
	}
	ds_list_add(controlData, _controlData);
	
	// 
	if (_calculatePositions) {control_info_calculate_positions(_anchor);}
}

/// @description 
/// @param index
function control_info_remove_control_data(_index){
	var _anchor = controlData[| _index].anchor;
	
	// 
	delete controlData[| _index];
	ds_list_delete(controlData, _index);
	
	// 
	control_info_calculate_positions(_anchor);
}

/// @description 
function control_info_clear_all(){
	var _length = ds_list_size(controlData);
	for (var i = 0; i < _length; i++) {delete controlData[| i];}
	ds_list_clear(controlData);
}

/// @description 
/// @param index
function control_info_calculate_positions(_anchor){
	// 
	var _anchorPos = [0, 0];
	if (_anchor == LEFT_ANCHOR) {_anchorPos = leftAnchor;}
	else if (_anchor == RIGHT_ANCHOR) {_anchorPos = rightAnchor;}
	
	//
	draw_set_font(font_gui_small);
	
	//
	var _length, _offset;
	_length = ds_list_size(controlData);
	_offset = 0;
	for (var i = 0; i < _length; i++){
		with(controlData[| i]){
			// 
			if (anchor != _anchor) {continue;}
			
			// 
			sprPos = [_anchorPos[X] + (_offset * -_anchor), _anchorPos[Y] - 2];
			_offset += sprite_get_width(global.controlIcons[? iconKey][0]) + 2;
			
			// 
			if (infoText != ""){
				textPos = [_anchorPos[X] + (_offset * -_anchor), _anchorPos[Y]];
				_offset += string_width(infoText) + 6;
			}
		}
	}
}