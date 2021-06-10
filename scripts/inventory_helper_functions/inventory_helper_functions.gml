/// @description A simple function that allows the reusing of the inventory's section swapping code. It will
/// check the two auxillary menu direction inputs for left and right to see if any movement needs to be handled.
/// Then, the section will be chosen based on if it's to the "left" or to the "right" of the current section.
function inventory_section_swap_input(){
	// If no input is detected, the result is 0, but otherwise it will be 1 or -1 depending on the inputs
	var _nextSection = (keyAuxRight - keyAuxLeft);
	if (_nextSection != 0){
		// Get the next section's index and wrap it between 0 and 2 if necessary
		var _curSection = curSection + _nextSection;
		if (_curSection < 0) {_curSection = MAP_SECTION;}
		else if (_curSection > MAP_SECTION) {_curSection = 0;}
		inventory_initialize_section(_curSection);
		return true; // Returns true to prevent the state that called this from executing all its code
	}
	// The section wasn't changed, return false so the state that called this function can full execute
	return false;
}