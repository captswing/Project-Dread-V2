/// @description Detecting A Connected GamePad

//show_debug_message("Event: " + async_load[? "event_type"]);
//show_debug_message("Pad: " + string(async_load[? "pad_index"]));

switch(async_load[? "event_type"]){
	case "gamepad discovered": // A gamepad was found and connected
		if (global.gamepadID == -1){ // Only connects the first found gamepad
			global.gamepadID = async_load[? "pad_index"];
			gamepad_set_axis_deadzone(global.gamepadID, 0.25);		// The "deadzone" for the thumbsticks
			gamepad_set_button_threshold(global.gamepadID, 0.1);	// The "threshold" for the triggers
		}
		break;
	case "gamepad lost": // A gamepad was disconnected from the computer
		global.gamepadID = -1;
		global.gamepadActive = false;
		break;
}

// Initialize the correct images for the control icons
initialize_control_icons(global.gamepadActive);