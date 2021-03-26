/// @description Formats a number with an indeterminate amount of zeros added to it. For example, if the zero 
/// value is "000", then an input number of 17 will be formatted like "017". If the number input is 1000, but 
/// the zero value is "000", the result will be "999+" instead of "1000".
/// @param value
/// @param zeroStrValue
function number_format(_value, _zeroStrValue){
	// Convert the number to a string
	_value = string(_value);
	
	// Calculate the length of the two strings that were input
	var _numberStringLength, _zeroValueLength;
	_numberStringLength = string_length(_value);
	_zeroValueLength = string_length(_zeroStrValue);
	
	// If the number provided is larger than the available space, return it as "9" repeating for the total number
	// of zeroes that were provided in the argument space.
	if (_numberStringLength > _zeroValueLength){
		return string_repeat("9", _zeroValueLength) + "+";
	}
	
	// Add the number value into the string, and delete the zeroes that the number is replacing
	_zeroStrValue = string_insert(_value, _zeroStrValue, 1 + _zeroValueLength - _numberStringLength);
	_zeroStrValue = string_delete(_zeroStrValue, 1 + _zeroValueLength, _numberStringLength);
	
	return string_digits(_zeroStrValue);
}

/// @description Displays a single number value (Ex. a timer) as time in the HH:MM:SS format.
/// @param value
function number_as_time(_value){
	// Check if the provided number goes above the maximum of "99:59:59"
	if (_value >= MAX_TIME_VALUE){
		return "99:59:59";
	}
	
	// First, apply the conversion calculates for the number provided
	var _seconds, _minutes, _hours;
	_seconds = _value mod 60;
	_minutes = floor(_value / 60) mod 60;
	_hours = floor(_value / 3600);
	
	// Finally, convert the resulting numbers into the final HH:MM:SS format
	return number_format(_hours, "00") + ":" + number_format(_minutes, "00") + ":" + number_format(_seconds, "00");
}