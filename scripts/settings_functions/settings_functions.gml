/// @description Attempts to load in data from the "settings.ini" file. If the file doesn't exist, default 
/// values will be set for all available settings.
function load_settings(){
	ini_open(SETTINGS_FILE);
	
	// Video Settings //
	var _video = "VIDEO";
	global.settings[Settings.ResolutionScale] =		ini_read_real(_video, "resolution_scale",		4);
	global.settings[Settings.FullScreen] =			ini_read_real(_video, "fullscreen_mode",		false);
	global.settings[Settings.Brightness] =			ini_read_real(_video, "brightness",				1);
	global.settings[Settings.Contrast] =			ini_read_real(_video, "contrast",				1);
	global.settings[Settings.Saturation] =			ini_read_real(_video, "saturation",				1);
	global.settings[Settings.Gamma]	=				ini_read_real(_video, "gamma",					1);
	global.settings[Settings.Bloom] =				ini_read_real(_video, "bloom_effect",			true);
	global.settings[Settings.Aberration] =			ini_read_real(_video, "chromatic_aberration",	true);
	global.settings[Settings.Scanlines] =			ini_read_real(_video, "scanlines",				true);
	global.settings[Settings.FilmGrain] =			ini_read_real(_video, "film_grain",				true);
													
	// Audio Settings //							
	var _audio = "AUDIO";							
	global.settings[Settings.Master] =				ini_read_real(_audio, "master",					100);
	global.settings[Settings.Sounds] =				ini_read_real(_audio, "sound_effects",			85);
	global.settings[Settings.Music] =				ini_read_real(_audio, "music",					75);
	global.settings[Settings.EnableMusic] =			ini_read_real(_audio, "enable_music",			true);
													
	// Control Settings (Keyboard) //							
	var _controls = "CONTROLS (KEYBOARD)";						
	global.settings[Settings.GameRight] =			ini_read_real(_controls, "game_right",			vk_right);		// In-Game Controls
	global.settings[Settings.GameLeft] =			ini_read_real(_controls, "game_left",			vk_left);
	global.settings[Settings.GameUp] =				ini_read_real(_controls, "game_up",				vk_up);
	global.settings[Settings.GameDown] =			ini_read_real(_controls, "game_down",			vk_down);
	global.settings[Settings.Run] =					ini_read_real(_controls, "run",					vk_shift);
	global.settings[Settings.ReadyWeapon] =			ini_read_real(_controls, "ready_weapon",		ord("X"));
	global.settings[Settings.UseWeapon] =			ini_read_real(_controls, "use_weapon",			ord("Z"));
	global.settings[Settings.Reload] =				ini_read_real(_controls, "reload",				ord("R"));
	global.settings[Settings.AmmoSwap] =			ini_read_real(_controls, "ammo_swap",			vk_control);
	global.settings[Settings.Flashlight] =			ini_read_real(_controls, "flashlight",			ord("F"));
	global.settings[Settings.Interact] =			ini_read_real(_controls, "interact",			ord("Z"));
	global.settings[Settings.Items] =				ini_read_real(_controls, "items",				vk_tab);
	global.settings[Settings.Maps] =				ini_read_real(_controls, "maps",				ord("M"));
	global.settings[Settings.Notes] =				ini_read_real(_controls, "notes",				ord("N"));
	global.settings[Settings.Pause] =				ini_read_real(_controls, "pause_menu",			vk_escape);
	global.settings[Settings.MenuRight] =			ini_read_real(_controls, "menu_right",			vk_right);		// Menu Controls
	global.settings[Settings.MenuLeft] =			ini_read_real(_controls, "menu_left",			vk_left);
	global.settings[Settings.MenuUp] =				ini_read_real(_controls, "menu_up",				vk_up);
	global.settings[Settings.MenuDown] =			ini_read_real(_controls, "menu_down",			vk_down);
	global.settings[Settings.Select] =				ini_read_real(_controls, "select_option",		ord("Z"));
	global.settings[Settings.Return] =				ini_read_real(_controls, "close_menu",			ord("X"));
	global.settings[Settings.FileDelete] =			ini_read_real(_controls, "delete_file",			ord("D"));
	
	// Control Settings (Gamepad) //
	var _controlsGP = "CONTROLS (GAMEPAD)";
	global.settings[Settings.GameRightGP] =			ini_read_real(_controlsGP, "game_right_gp",		gp_padr);		// In-Game Controls
	global.settings[Settings.GameLeftGP] =			ini_read_real(_controlsGP, "game_left_gp",		gp_padl);
	global.settings[Settings.GameUpGP] =			ini_read_real(_controlsGP, "game_up_gp",		gp_padu);
	global.settings[Settings.GameDownGP] =			ini_read_real(_controlsGP, "game_down_gp",		gp_padd);
	global.settings[Settings.RunGP] =				ini_read_real(_controlsGP, "run_gp",			gp_shoulderlb);
	global.settings[Settings.ReadyWeaponGP] =		ini_read_real(_controlsGP, "ready_weapon_gp",	gp_shoulderrb);
	global.settings[Settings.UseWeaponGP] =			ini_read_real(_controlsGP, "use_weapon_gp",		gp_face1);
	global.settings[Settings.ReloadGP] =			ini_read_real(_controlsGP, "reload_gp",			gp_face3);
	global.settings[Settings.AmmoSwapGP] =			ini_read_real(_controlsGP, "ammo_swap_gp",		gp_face2);
	global.settings[Settings.FlashlightGP] =		ini_read_real(_controlsGP, "flashlight_gp",		gp_face4);
	global.settings[Settings.InteractGP] =			ini_read_real(_controlsGP, "interact_gp",		gp_face1);
	global.settings[Settings.ItemsGP] =				ini_read_real(_controlsGP, "items_gp",			gp_shoulderl);
	global.settings[Settings.MapsGP] =				ini_read_real(_controlsGP, "maps_gp",			gp_select);
	global.settings[Settings.NotesGP] =				ini_read_real(_controlsGP, "notes_gp",			gp_shoulderr);
	global.settings[Settings.PauseGP] =				ini_read_real(_controlsGP, "pause_menu_GP",		gp_start);
	global.settings[Settings.MenuRightGP] =			ini_read_real(_controlsGP, "menu_right_GP",		gp_padr);		// Menu Controls
	global.settings[Settings.MenuLeftGP] =			ini_read_real(_controlsGP, "menu_left_GP",		gp_padl);
	global.settings[Settings.MenuUpGP] =			ini_read_real(_controlsGP, "menu_up_GP",		gp_padu);
	global.settings[Settings.MenuDownGP] =			ini_read_real(_controlsGP, "menu_down_GP",		gp_padd);
	global.settings[Settings.SelectGP] =			ini_read_real(_controlsGP, "select_option_GP",	gp_face1);
	global.settings[Settings.ReturnGP] =			ini_read_real(_controlsGP, "close_menu_GP",		gp_face2);
	global.settings[Settings.FileDeleteGP] =		ini_read_real(_controlsGP, "delete_file_GP",	gp_face4);
	
	// Accessibility Settings //
	var _access = "ACCESSIBILITY";
	global.settings[Settings.TextSpeed] =			ini_read_real(_access, "text_speed",			1.25);
	global.settings[Settings.ObjectiveHints] =		ini_read_real(_access, "objective_hints",		false);
	global.settings[Settings.ItemHighlighting] =	ini_read_real(_access, "item_highlighting",		false);
	global.settings[Settings.AimAssist] =			ini_read_real(_access, "aim_assist",			false);
	
	ini_close();
}

/// @description Saves the player's current settings to a file named "settings.ini". Upon loading up the 
/// game again, these settings will automatically be loaded into the settings array.
function save_settings(){
	ini_open(SETTINGS_FILE);
	
	// Video Settings //
	var _video = "VIDEO";
	ini_write_real(_video, "resolution_scale",		global.settings[Settings.ResolutionScale]);
	ini_write_real(_video, "fullscreen_mode",		global.settings[Settings.FullScreen]);
	ini_write_real(_video, "brightness",			global.settings[Settings.Brightness]);
	ini_write_real(_video, "contrast",				global.settings[Settings.Contrast]);
	ini_write_real(_video, "saturation",			global.settings[Settings.Saturation]);
	ini_write_real(_video, "gamma",					global.settings[Settings.Gamma]);
	ini_write_real(_video, "bloom_effect",			global.settings[Settings.Bloom]);
	ini_write_real(_video, "chromatic_aberration",	global.settings[Settings.Aberration]);
	ini_write_real(_video, "scanlines",				global.settings[Settings.Scanlines]);
	ini_write_real(_video, "film_grain",			global.settings[Settings.FilmGrain]);
	
	// Audio Settings //
	var _audio = "AUDIO";
	ini_write_real(_audio, "master",				global.settings[Settings.Master]);
	ini_write_real(_audio, "sound_effects",			global.settings[Settings.Sounds]);
	ini_write_real(_audio, "music",					global.settings[Settings.Music]);
	ini_write_real(_audio, "enable_music",			global.settings[Settings.EnableMusic]);
	
	// Control Settings (Keyboard) //
	var _controls = "CONTROLS (KEYBOARD)";
	ini_write_real(_controls, "game_right",			global.settings[Settings.GameRight]);		// In-Game Controls
	ini_write_real(_controls, "game_left",			global.settings[Settings.GameLeft]);
	ini_write_real(_controls, "game_up",			global.settings[Settings.GameUp]);
	ini_write_real(_controls, "game_down",			global.settings[Settings.GameDown]);
	ini_write_real(_controls, "run",				global.settings[Settings.Run]);
	ini_write_real(_controls, "ready_weapon",		global.settings[Settings.ReadyWeapon]);
	ini_write_real(_controls, "use_weapon",			global.settings[Settings.UseWeapon]);
	ini_write_real(_controls, "reload",				global.settings[Settings.Reload]);
	ini_write_real(_controls, "ammo_swap",			global.settings[Settings.AmmoSwap]);
	ini_write_real(_controls, "flashlight",			global.settings[Settings.Flashlight]);
	ini_write_real(_controls, "interact",			global.settings[Settings.Interact]);
	ini_write_real(_controls, "items",				global.settings[Settings.Items]);
	ini_write_real(_controls, "maps",				global.settings[Settings.Maps]);
	ini_write_real(_controls, "notes",				global.settings[Settings.Notes]);
	ini_write_real(_controls, "pause_menu",			global.settings[Settings.Pause]);
	ini_write_real(_controls, "menu_right",			global.settings[Settings.MenuRight]);		// Menu Controls
	ini_write_real(_controls, "menu_left",			global.settings[Settings.MenuLeft]);
	ini_write_real(_controls, "menu_up",			global.settings[Settings.MenuUp]);
	ini_write_real(_controls, "menu_down",			global.settings[Settings.MenuDown]);
	ini_write_real(_controls, "select_option",		global.settings[Settings.Select]);
	ini_write_real(_controls, "close_menu",			global.settings[Settings.Return]);
	ini_write_real(_controls, "delete_file",		global.settings[Settings.FileDelete]);
	
	// Control Settings (Gamepad) //
	var _controlsGP = "CONTROLS (GAMEPAD)";
	ini_write_real(_controlsGP, "game_right_gp",	global.settings[Settings.GameRightGP]);		// In-Game Controls
	ini_write_real(_controlsGP, "game_left_gp",		global.settings[Settings.GameLeftGP]);
	ini_write_real(_controlsGP, "game_up_gp",		global.settings[Settings.GameUpGP]);
	ini_write_real(_controlsGP, "game_down_gp",		global.settings[Settings.GameDownGP]);
	ini_write_real(_controlsGP, "run_gp",			global.settings[Settings.RunGP]);
	ini_write_real(_controlsGP, "ready_weapon_gp",	global.settings[Settings.ReadyWeaponGP]);
	ini_write_real(_controlsGP, "use_weapon_gp",	global.settings[Settings.UseWeaponGP]);
	ini_write_real(_controlsGP, "reload_gp",		global.settings[Settings.ReloadGP]);
	ini_write_real(_controlsGP, "ammo_swap_gp",		global.settings[Settings.AmmoSwapGP]);
	ini_write_real(_controlsGP, "flashlight_gp",	global.settings[Settings.FlashlightGP]);
	ini_write_real(_controlsGP, "interact_gp",		global.settings[Settings.InteractGP]);
	ini_write_real(_controlsGP, "items_gp",			global.settings[Settings.ItemsGP]);
	ini_write_real(_controlsGP, "maps_gp",			global.settings[Settings.MapsGP]);
	ini_write_real(_controlsGP, "notes_gp",			global.settings[Settings.NotesGP]);
	ini_write_real(_controlsGP, "pause_menu_gp",	global.settings[Settings.PauseGP]);
	ini_write_real(_controlsGP, "menu_right_gp",	global.settings[Settings.MenuRightGP]);		// Menu Controls
	ini_write_real(_controlsGP, "menu_left_gp",		global.settings[Settings.MenuLeftGP]);
	ini_write_real(_controlsGP, "menu_up_gp",		global.settings[Settings.MenuUpGP]);
	ini_write_real(_controlsGP, "menu_down_gp",		global.settings[Settings.MenuDownGP]);
	ini_write_real(_controlsGP, "select_option_gp",	global.settings[Settings.SelectGP]);
	ini_write_real(_controlsGP, "close_menu_gp",	global.settings[Settings.ReturnGP]);
	ini_write_real(_controlsGP, "delete_file_gp",	global.settings[Settings.FileDeleteGP]);
	
	// Accessibility Settings //
	var _access = "ACCESSIBILITY";
	ini_write_real(_access, "text_speed",			global.settings[Settings.TextSpeed]);
	ini_write_real(_access, "objective_hints",		global.settings[Settings.ObjectiveHints]);
	ini_write_real(_access, "item_highlighting",	global.settings[Settings.ItemHighlighting]);
	ini_write_real(_access, "aim_assist",			global.settings[Settings.AimAssist]);
	
	ini_close();
}

/// @description Adjusts the player's non-control mapping setting values.
function adjust_setting(_index, _adjustValue){
	if (_index >= Settings.GameRight && _index <= Settings.FileDelete){
		return;
	}
	
	// Adjusting non-control player settings
	switch(_index){
		case Settings.ResolutionScale:
			global.settings[_index] += _adjustValue; // Keeps increasing the scale by one until the display's resolution has been exceeded
			if (global.settings[_index] * WINDOW_WIDTH > display_get_width() || global.settings[_index] * WINDOW_HEIGHT > display_get_height()){
				global.settings[_index] = 1; // Resets the resolution back to 320 by 180
			}
			// TODO -- Update camera and shader stuff here
			break;
		case Settings.FullScreen:
			global.settings[_index] = !global.settings[_index];
			// TODO -- Update camera and shader stuff here
			break;
		case Settings.Brightness:
		case Settings.Contrast:
		case Settings.Saturation:
		case Settings.Gamma:
			global.settings[_index] += _adjustValue * 0.1;
			if (global.settings[_index] > 2){ // Wrap back around to the lowest possible value
				global.settings[_index] = 0.5;
			} else if (global.settings[_index] < 0.5){ // Wrap around to the highest possible value
				global.settings[_index] = 2;
			}
			break;
		case Settings.Master:
		case Settings.Sounds:
		case Settings.Music:
			global.settings[_index] += _adjustValue * 5;
			if (global.settings[_index] > 100){ // Wrap back around to the lowest possible value
				global.settings[_index] = 0;
			} else if (global.settings[_index] < 0){ // Wrap around to the highest possible value
				global.settings[_index] = 100;
			}
			break;
		case Settings.EnableMusic:
			global.settings[_index] = !global.settings[_index];
			// TODO -- Start/Stop the background music here
			break;
		case Settings.TextSpeed:
			var _textSpeeds = [0, 0.33, 0.75, 1, 1.5, 2, 3]; // Zero is instantaneous text scrolling
			// Find what value the setting currently is, default to 1 if a value cannot be found
			var _length = array_length(_textSpeeds);
			for (var i = 0; i < _length; i++){
				if (_textSpeeds[i] == global.settings[_index]){
					if (i == _length - 1){ // Wrap around to the lowest possible value
						global.settings[_index] = _textSpeeds[0];
					} else if (i == 0){ // Wrap around to the highest possible value
						global.settings[_index] = _textSpeeds[_length - 1];
					}
					return;
				}
			}
			// No valid text speed value was found
			global.settings[_index] = _textSpeeds[3];
			break;
		default: // Default -- Toggles the value to be either true or false; everything else is automatic
			global.settings[_index] = !global.settings[_index];
			break;
	}
}