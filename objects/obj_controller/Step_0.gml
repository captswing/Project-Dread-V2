/// @description Updating Background Music and In-Game Timer

// Call the script that updates the currently playing background music
update_background_music();

// Accurately tracking the current in-game playtime whenever the timer is activated
// The value 35999999 is equal to 99:59:59 when converted, which is the maximum possible
// value it can display without making the hours value a 3 digit number.
if (!global.freezeTimer && global.totalPlaytime < MAX_TIME_VALUE){
	frameTimer += global.deltaTime;
	if (frameTimer > 60){
		frameTimer -= 60;
		global.totalPlaytime++;
		global.playtimeString = number_as_time(global.totalPlaytime);
	}
}

// Allows for hotswapping between the gamepad controls and keyboard controls in real-time. However,
// the hot swapping code won't run at all if there is no gamepad currently conntected to the PC.
if (global.gamepadID != -1){
	if (!global.gamepadActive && gamepad_any_button(true)){
		global.gamepadActive = true; // Activates the gamepad for use
		initialize_control_icons(true); // Update to gamepad icons
	} else if (keyboard_check_pressed(vk_anykey)){
		global.gamepadActive = false; // Activates the keyboard for use
		initialize_control_icons(false);  // Update to keyboard icons
	}
}