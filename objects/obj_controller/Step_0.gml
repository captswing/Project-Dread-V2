/// @description Updating the Current BGM, Current In-Game Playtime, and Handling Gamepad Stuff

// Call the script that updates the currently playing background music
update_background_music();

// Updating the currently active weather object
with(weather) {weather_update();}

// Updating the fade effect, dealing with it when its completed its animation
if (fade != noone){
	var _isDestroyed = false;
	with(fade){
		fade_update();
		// The fade has completed, signal to the controller that the fade should be deleted
		if (alpha <= 0 && fadingOut){
			set_game_state(global.prevGameState, true);
			_isDestroyed = true;
		}
	}
	// Removing the fade object from memory
	if (_isDestroyed){
		delete fade;
		fade = noone;
	}
}

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
	} else if (keyboard_check_pressed(vk_anykey)){
		global.gamepadActive = false; // Activates the keyboard for use
	}
}