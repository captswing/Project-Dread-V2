/// @description Checks for input from any available button or thumbsitck on the connected gamepad. A zero 
/// will be returned if no gamepad is currently connected to the computer.
/// @param includeSticks
function gamepad_any_button(_includeSticks){
	if (!gamepad_is_connected(global.gamepadID)){
		return; // The gamepad is no longer connected, don't check for input
	}
	// Loop through all gamepad buttons and triggers for any detected input. Return
	// the constant value for the relative input that was detected.
	for (var i = gp_face1; i <= gp_padr; i++){
		if (gamepad_button_check(global.gamepadID, i)) {return i;}
	}
	// Loop through the four directions of the two thumbsticks on the gamepad. Return
	// the constant value for the relative input that was detected.
	if (_includeSticks){
		for (var i = gp_axislh; i <= gp_axisrv; i++){
			if (gamepad_axis_value(global.gamepadID, i) != 0) {return i;}
		}
	}
	// If no input was detected, a zero will be returned.
	return 0;
}