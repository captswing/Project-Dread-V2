/// @description Converts a ds_list into an array. This is useful for using script_execute_ext when using data
/// that was pulled from a json, which can only ever be a ds_map or a ds_list data type. An important note about
/// this function is it doesn't remove the ds_list from memory, so don't forget to delete if it's not being used
/// anymore to avoid memory leaks.
/// @param list
function ds_list_to_array(_list){
	// If an invalid ds_list was put into the argument parameter, return an empty array.
	if (is_undefined(_list)) {return array_create(0, 0);}
	// Loop through the ds_list and set all its values within the array before returning the resulting array.
	var _length, _array;
	_length = ds_list_size(_list);
	for (var i = 0; i < _length; i++){
		_array[i] = _list[| i];
	}
	return _array;
}

/// @description Converts an array into a ds_list. This is useful for saving an array into a JSON file format,
/// which uses a ds_map to encode the data for writing to the save file. Since it's loaded back in as a list
/// if it's saved in this format, it makes sense that it needs to be saved as such as well.
/// @param array
function array_to_ds_list(_array){
	// If an invalid array was put in the argument parameter, return an error value (-1).
	if (!is_array(_array)) {return -1;}
	// Loop through the array and set all its values to the values of the array, then return that list.
	var _length, _list;
	_length = array_length(_array);
	_list = ds_list_create();
	for (var i = 0; i < _length; i++){
		ds_list_add(_list, _array[i]);
	}
	return _list;
}