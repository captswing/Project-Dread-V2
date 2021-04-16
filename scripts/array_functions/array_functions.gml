/// @description Converts a ds_list into an array. This is useful for using script_execute_ext when using data
/// that was pulled from a json, which can only ever be a ds_map or a ds_list data type. An important note about
/// this function is it doesn't remove the ds_list from memory, so don't forget to delete if it's not being used
/// anymore to avoid memory leaks.
/// @param list
function ds_list_to_array(_list){
	// If an invalid ds_list was put into the argument parameter, return an empty array.
	if (is_undefined(_list)){
		return array_create(0, 0);
	}
	// Loop through the ds_list and set all its values within the array before returning the resulting array.
	var _length, _array;
	_length = ds_list_size(_list);
	for (var i = 0; i < _length; i++){
		_array[i] = _list[| i];
	}
	return _array;
}