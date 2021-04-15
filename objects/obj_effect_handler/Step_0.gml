/// @description Updating Screen Fade and Weather If They Exist

// Updating the fade effect, dealing with it when its completed its animation
if (fade != noone){
	var _isDestroyed = false;
	with(fade){
		fade_update();
		// The fade has completed, signal to the handler that the fade should be deleted
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

// Updating the currently active weather object and handle closing transition for changing effects.
var _isDestroyed = false;
with(weather){
	weather_update();
	_isDestroyed = isDestroyed;
}
// Change the effect once the weather effect is considered "destroyed"
if (_isDestroyed) {change_weather_effect(weatherType, 0);}

// DEBUGGING COMMANDS //

var _key = keyboard_check_pressed(vk_anykey);
if (_key){ // Only search through the switch tree if a key was actually pressed
	switch(keyboard_lastkey){
		case 49:	// Key -- "1"	(Toggling Global Lighting)
			lightingEnabled = !lightingEnabled;
			break;
		case 50:	// Key -- "2"	(Toggling Bloom)
			global.settings[Settings.Bloom] = !global.settings[Settings.Bloom];
			break;
		case 51:	// Key -- "3"	(Toggline Screen Blur)
			blurEnabled = !blurEnabled;
			break;
		case 52:	// Key -- "4"	(Toggling Chromatic Aberration)
			global.settings[Settings.Aberration] = !global.settings[Settings.Aberration];
			break;
		case 53:	// Key -- "5"	(Toggling Film Grain)
			global.settings[Settings.FilmGrain] = !global.settings[Settings.FilmGrain];
			break;
		case 54:	// Key -- "6"	(Toggling Scanlines)
			global.settings[Settings.Scanlines] = !global.settings[Settings.Scanlines];
			break;
		case 55:	// Key -- "7"	(Toggling Mist Weather)
			if (weather == noone) {set_weather(Weather.Mist, 0);}
			else {set_weather(Weather.Clear, 0);}
			break;
		case 56:	// Key -- "8"	(Toggling Screen Fade)
			create_screen_fade(c_black, 0.05, 60);
			break;
	}
}