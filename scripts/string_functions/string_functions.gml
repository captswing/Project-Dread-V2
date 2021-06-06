/// @description Splits a single line of characters into multiple lines based on the maximum possible width
/// and font provided for the calculation. If another font is used with this string, the dimensions will not
/// be properly adjusted SO MAKE SURE TO UPDATE THE CALCULATIONS IF FONTS CHANGE AT ALL.
/// @param string
/// @param width
/// @param font
function string_split_lines(_string, _width, _font){
	// Important variables for the function. ONe holds the current word in the provided string, the next
	// holds the current parsed line that will be added to the final string (the last variable) once the
	// current word plus the current line exceed the maximum width of the string.
	var _curWord, _curLine, _newString;
	_curWord = "";
	_curLine = "";
	_newString = "";
	
	// The font must be set to whatever font will be used when displaying this text. Otherwise, the width
	// used to split the lines won't be properly preserved. This is just a side effect with how GMS handles
	// its string menipulation functions.
	draw_set_font(_font);
	
	// Loop through the provided string, adding each character to the _newString variable until the width
	// of the current line is exceeded by the next word being added to it, which adds a new line accordingly.
	var _length, _char;
	_length = string_length(_string);
	for (var i = 1; i <= _length; i++){
		_char = string_char_at(_string, i);
		if (_char == " "){ // A space was found, handle what should happen next
			if (string_width(" " + _curWord) + string_width(_curLine) > _width){ // Move the word onto the next line and continue
				_newString += _curLine + "\n";
				_curLine = _curWord;
			} else{ // There is enough room on the current line; add the word to it
				if (_curLine != "") {_curLine += " " + _curWord;}
				else {_curLine += _curWord;}
			}
			// Reset the current word string and begin getting building the next word
			_curWord = "";
			continue; // Ignores the space character in the original string
		}
		_curWord += _char;
	}
	// Add the remaining data to the string, as it isn't picked up by the loop
	if (string_width(" " + _curWord) + string_width(_curLine) > _width){ // Final word goes onto its own line
		_newString += _curLine + "\n" + _curWord;
	} else if (_curLine != ""){ // Final word is added onto together with the current line and put into the string
		_newString += _curLine + " " + _curWord;
	} else{ // Final word is just added to the string since no other text exists.
		_newString += _curWord;
	}
	
	// Finally, return the formatted string back to wherever called this function
	return _newString;
}

/// @description Splits a single string into an array of multiple string values based on the provided delimiter
/// value. If this delim value is longer than one character, however, the function will not function and an
/// empty array will be returned. Otherwise, an array of split up strings will be returned by the function.
/// @param string
/// @param delim
function string_split(_string, _delim){
	// Important variables for properly splitting one string into an array of multiple strings based on a
	// delimiter value. The first stores the parsed string data in an array while the second stores the
	// string data in between parses.
	var _data, _newString;
	_data = array_create(0, "");
	_newString = "";
	
	// Loop through the string until the delimiter character is hit by the loop. Once that happens, the text
	// from the start/previous delimiter all the way to the current character will be parsed into its own
	// string, which is placed into the array.
	var _length, _char;
	_length = string_length(_string);
	for (var i = 0; i < _length; i++){
		_char = string_char_at(_string, i);
		if (_char == _delim){ // The delimiter character was found, push the string up to that point into the array of strings
			array_push(_data, _newString);
			_newString = "";
			continue;
		}
		_newString += _char;
	}
	// Adds the final string to the data array, since the last chunk never gets hit by the loop
	array_push(_data, _newString);
	
	// Finally, send the split string data back to wherever this function was called from
	return _data;
}

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