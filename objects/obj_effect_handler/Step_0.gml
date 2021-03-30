/// @description DEBUG COMMANDS

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
		case 53:	// Key -- "5"	(Toggling Heat Haze)
			isHazeEnabled = !isHazeEnabled;
			break;
		case 54:	// Key -- "6"	(Toggling Film Grain)
			global.settings[Settings.FilmGrain] = !global.settings[Settings.FilmGrain];
			break;
		case 55:	// Key -- "7"	(Toggling Scanlines)
			global.settings[Settings.Scanlines] = !global.settings[Settings.Scanlines];
			break;
	}
}