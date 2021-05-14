/// @description Initializes the control icons based on a few different factors. The first and most important
/// factor is whether or not a connected gamepad is currently being used. Other than that, the icons are
/// selected based on what control is set for the variable's given action.
/// @param gamepadActive
function initialize_control_icons(_gamepadActive){
	if (_gamepadActive){ // The gamepad is active; reflect that in the control icons
		// In-game control icons //
		ds_map_set(global.controlIcons, ICON_GAME_RIGHT,	gamepad_get_sprite(global.settings[Settings.GameRightGP]));
		ds_map_set(global.controlIcons, ICON_GAME_LEFT,		gamepad_get_sprite(global.settings[Settings.GameLeftGP]));
		ds_map_set(global.controlIcons, ICON_GAME_UP,		gamepad_get_sprite(global.settings[Settings.GameUpGP]));
		ds_map_set(global.controlIcons, ICON_GAME_DOWN,		gamepad_get_sprite(global.settings[Settings.GameDownGP]));
		ds_map_set(global.controlIcons, ICON_RUN,			gamepad_get_sprite(global.settings[Settings.RunGP]));
		ds_map_set(global.controlIcons, ICON_FLASHLIGHT,	gamepad_get_sprite(global.settings[Settings.FlashlightGP]));
		ds_map_set(global.controlIcons, ICON_INTERACT,		gamepad_get_sprite(global.settings[Settings.InteractGP]));
		ds_map_set(global.controlIcons, ICON_AMMO_SWAP,		gamepad_get_sprite(global.settings[Settings.AmmoSwapGP]));
		ds_map_set(global.controlIcons, ICON_RELOAD,		gamepad_get_sprite(global.settings[Settings.ReloadGP]));
		ds_map_set(global.controlIcons, ICON_READY_WEAPON,	gamepad_get_sprite(global.settings[Settings.ReadyWeaponGP]));
		ds_map_set(global.controlIcons, ICON_USE_WEAPON,	gamepad_get_sprite(global.settings[Settings.UseWeaponGP]));
		ds_map_set(global.controlIcons, ICON_PAUSE,			gamepad_get_sprite(global.settings[Settings.PauseGP]));
		ds_map_set(global.controlIcons, ICON_NOTES,			gamepad_get_sprite(global.settings[Settings.NotesGP]));
		ds_map_set(global.controlIcons, ICON_MAPS,			gamepad_get_sprite(global.settings[Settings.MapsGP]));
		ds_map_set(global.controlIcons, ICON_NOTES,			gamepad_get_sprite(global.settings[Settings.ItemsGP]));
		// Menu control icons //
		ds_map_set(global.controlIcons, ICON_MENU_RIGHT,	gamepad_get_sprite(global.settings[Settings.MenuRightGP]));
		ds_map_set(global.controlIcons, ICON_MENU_LEFT,		gamepad_get_sprite(global.settings[Settings.MenuLeftGP]));
		ds_map_set(global.controlIcons, ICON_MENU_UP,		gamepad_get_sprite(global.settings[Settings.MenuUpGP]));
		ds_map_set(global.controlIcons, ICON_MENU_DOWN,		gamepad_get_sprite(global.settings[Settings.MenuDownGP]));
		ds_map_set(global.controlIcons, ICON_SELECT,		gamepad_get_sprite(global.settings[Settings.SelectGP]));
		ds_map_set(global.controlIcons, ICON_RETURN,		gamepad_get_sprite(global.settings[Settings.ReturnGP]));
		ds_map_set(global.controlIcons, ICON_FILE_DELETE,	gamepad_get_sprite(global.settings[Settings.FileDeleteGP]));
	} else{ // The gamepad isn't active; normal keyboard keys will be used
		// In-game control icons //
		ds_map_set(global.controlIcons, ICON_GAME_RIGHT,	keyboard_get_sprite(global.settings[Settings.GameRight]));
		ds_map_set(global.controlIcons, ICON_GAME_LEFT,		keyboard_get_sprite(global.settings[Settings.GameLeft]));
		ds_map_set(global.controlIcons, ICON_GAME_UP,		keyboard_get_sprite(global.settings[Settings.GameUp]));
		ds_map_set(global.controlIcons, ICON_GAME_DOWN,		keyboard_get_sprite(global.settings[Settings.GameDown]));
		ds_map_set(global.controlIcons, ICON_RUN,			keyboard_get_sprite(global.settings[Settings.Run]));
		ds_map_set(global.controlIcons, ICON_FLASHLIGHT,	keyboard_get_sprite(global.settings[Settings.Flashlight]));
		ds_map_set(global.controlIcons, ICON_INTERACT,		keyboard_get_sprite(global.settings[Settings.Interact]));
		ds_map_set(global.controlIcons, ICON_AMMO_SWAP,		keyboard_get_sprite(global.settings[Settings.AmmoSwap]));
		ds_map_set(global.controlIcons, ICON_RELOAD,		keyboard_get_sprite(global.settings[Settings.Reload]));
		ds_map_set(global.controlIcons, ICON_READY_WEAPON,	keyboard_get_sprite(global.settings[Settings.ReadyWeapon]));
		ds_map_set(global.controlIcons, ICON_USE_WEAPON,	keyboard_get_sprite(global.settings[Settings.UseWeapon]));
		ds_map_set(global.controlIcons, ICON_PAUSE,			keyboard_get_sprite(global.settings[Settings.Pause]));
		ds_map_set(global.controlIcons, ICON_NOTES,			keyboard_get_sprite(global.settings[Settings.Notes]));
		ds_map_set(global.controlIcons, ICON_MAPS,			keyboard_get_sprite(global.settings[Settings.Maps]));
		ds_map_set(global.controlIcons, ICON_NOTES,			keyboard_get_sprite(global.settings[Settings.Items]));
		// Menu control icons //
		ds_map_set(global.controlIcons, ICON_MENU_RIGHT,	keyboard_get_sprite(global.settings[Settings.MenuRight]));
		ds_map_set(global.controlIcons, ICON_MENU_LEFT,		keyboard_get_sprite(global.settings[Settings.MenuLeft]));
		ds_map_set(global.controlIcons, ICON_MENU_UP,		keyboard_get_sprite(global.settings[Settings.MenuUp]));
		ds_map_set(global.controlIcons, ICON_MENU_DOWN,		keyboard_get_sprite(global.settings[Settings.MenuDown]));
		ds_map_set(global.controlIcons, ICON_SELECT,		keyboard_get_sprite(global.settings[Settings.Select]));
		ds_map_set(global.controlIcons, ICON_RETURN,		keyboard_get_sprite(global.settings[Settings.Return]));
		ds_map_set(global.controlIcons, ICON_FILE_DELETE,	keyboard_get_sprite(global.settings[Settings.FileDelete]));
	}
}

/// @description Gets a given sprite from the keycode that was provided in the argument space. If an invalid 
/// key code was provided, the default configuration of the 1st small keybinding sprite will be returned, which
/// is the Up Arrow key's sprite.
/// @param keyCode
function keyboard_get_sprite(_keyCode){
	switch(_keyCode){ // Returns an array in the form of [sprite_index, image_index]
		case 8:		return [spr_keyboard_icons_large, 1];		// Backspace
		case 9:		return [spr_keyboard_icons_large, 13];		// Tab
		case 13:	return [spr_keyboard_icons_small, 36];		// Enter
		case 16:	return [spr_keyboard_icons_large, 5];		// Shift
		case 20:	return [spr_keyboard_icons_large, 2];		// Caps Lock
		case 27:	return [spr_keyboard_icons_large, 2];		// Escape
		case 32:	return [spr_keyboard_icons_large, 0];		// Space
		case 33:	return [spr_keyboard_icons_large, 11];		// Page Up
		case 34:	return [spr_keyboard_icons_large, 12];		// Page Down
		case 35:	return [spr_keyboard_icons_large, 10];		// End
		case 36:	return [spr_keyboard_icons_large, 9];		// Home
		case 37:	return [spr_keyboard_icons_small, 2];		// Left Arrow
		case 38:	return [spr_keyboard_icons_small, 0];		// Up Arrow
		case 39:	return [spr_keyboard_icons_small, 3];		// Right Arrow
		case 40:	return [spr_keyboard_icons_small, 1];		// Down Arrow
		case 45:	return [spr_keyboard_icons_large, 7];		// Insert
		case 46:	return [spr_keyboard_icons_large, 8];		// Delete
		case 47:	return [spr_keyboard_icons_small, 53];		// 0
		case 48:	return [spr_keyboard_icons_small, 44];		// 1
		case 49:	return [spr_keyboard_icons_small, 45];		// 2
		case 50:	return [spr_keyboard_icons_small, 46];		// 3
		case 51:	return [spr_keyboard_icons_small, 47];		// 4
		case 52:	return [spr_keyboard_icons_small, 48];		// 5
		case 53:	return [spr_keyboard_icons_small, 49];		// 6
		case 54:	return [spr_keyboard_icons_small, 50];		// 7
		case 55:	return [spr_keyboard_icons_small, 51];		// 8
		case 56:	return [spr_keyboard_icons_small, 52];		// 9
		case 65:	return [spr_keyboard_icons_small, 4];		// A
		case 66:	return [spr_keyboard_icons_small, 5];		// B
		case 67:	return [spr_keyboard_icons_small, 6];		// C
		case 68:	return [spr_keyboard_icons_small, 7];		// D
		case 69:	return [spr_keyboard_icons_small, 8];		// E
		case 70:	return [spr_keyboard_icons_small, 9];		// F
		case 71:	return [spr_keyboard_icons_small, 10];		// G
		case 72:	return [spr_keyboard_icons_small, 11];		// H
		case 73:	return [spr_keyboard_icons_small, 12];		// I
		case 74:	return [spr_keyboard_icons_small, 13];		// J
		case 75:	return [spr_keyboard_icons_small, 14];		// K
		case 76:	return [spr_keyboard_icons_small, 15];		// L
		case 77:	return [spr_keyboard_icons_small, 16];		// M
		case 78:	return [spr_keyboard_icons_small, 17];		// N
		case 79:	return [spr_keyboard_icons_small, 18];		// O
		case 80:	return [spr_keyboard_icons_small, 19];		// P
		case 81:	return [spr_keyboard_icons_small, 20];		// Q
		case 82:	return [spr_keyboard_icons_small, 21];		// R
		case 83:	return [spr_keyboard_icons_small, 22];		// S
		case 84:	return [spr_keyboard_icons_small, 23];		// T
		case 85:	return [spr_keyboard_icons_small, 24];		// U
		case 86:	return [spr_keyboard_icons_small, 25];		// V
		case 87:	return [spr_keyboard_icons_small, 26];		// W
		case 88:	return [spr_keyboard_icons_small, 27];		// X
		case 89:	return [spr_keyboard_icons_small, 28];		// Y
		case 90:	return [spr_keyboard_icons_small, 29];		// Z
		case 96:	return [spr_keyboard_icons_large, 26];		// Numpad 0
		case 97:	return [spr_keyboard_icons_large, 27];		// Numpad 1
		case 98:	return [spr_keyboard_icons_large, 28];		// Numpad 2
		case 99:	return [spr_keyboard_icons_large, 29];		// Numpad 3
		case 100:	return [spr_keyboard_icons_large, 30];		// Numpad 4
		case 101:	return [spr_keyboard_icons_large, 31];		// Numpad 5
		case 102:	return [spr_keyboard_icons_large, 32];		// Numpad 6
		case 103:	return [spr_keyboard_icons_large, 33];		// Numpad 7
		case 104:	return [spr_keyboard_icons_large, 34];		// Numpad 8
		case 105:	return [spr_keyboard_icons_large, 35];		// Numpad 9
		case 106:	return [spr_keyboard_icons_small, 42];		// Multiply
		case 107:	return [spr_keyboard_icons_small, 39];		// Add
		case 109:	return [spr_keyboard_icons_small, 40];		// Subtract
		case 111:	return [spr_keyboard_icons_small, 32];		// Divide
		case 112:	return [spr_keyboard_icons_large, 14];		// F1
		case 113:	return [spr_keyboard_icons_large, 15];		// F2
		case 114:	return [spr_keyboard_icons_large, 16];		// F3
		case 115:	return [spr_keyboard_icons_large, 17];		// F4
		case 116:	return [spr_keyboard_icons_large, 18];		// F5
		case 117:	return [spr_keyboard_icons_large, 19];		// F6
		case 118:	return [spr_keyboard_icons_large, 20];		// F7
		case 119:	return [spr_keyboard_icons_large, 21];		// F8
		case 120:	return [spr_keyboard_icons_large, 22];		// F9
		case 121:	return [spr_keyboard_icons_large, 23];		// F10
		case 122:	return [spr_keyboard_icons_large, 24];		// F11
		case 123:	return [spr_keyboard_icons_large, 25];		// F12
		case 162:	return [spr_keyboard_icons_large, 6];		// Left Control
		case 163:	return [spr_keyboard_icons_large, 37];		// Right Control
		case 164:	return [spr_keyboard_icons_large, 3];		// Left Alt
		case 165:	return [spr_keyboard_icons_large, 36];		// Right Alt
		case 186:	return [spr_keyboard_icons_small, 33];		// Colon/Semi-Colon
		case 187:	return [spr_keyboard_icons_small, 55];		// Equal
		case 188:	return [spr_keyboard_icons_small, 30];		// Comma
		case 189:	return [spr_keyboard_icons_small, 40];		// Underscore
		case 190:	return [spr_keyboard_icons_small, 31];		// Period
		case 191:	return [spr_keyboard_icons_small, 41];		// Question Mark
		case 192:	return [spr_keyboard_icons_small, 43];		// Tilde
		case 219:	return [spr_keyboard_icons_small, 34];		// Open Curly/Square Bracket
		case 220:	return [spr_keyboard_icons_small, 37];		// Backslash
		case 221:	return [spr_keyboard_icons_small, 35];		// Close Curly/Square Bracket
		case 222:	return [spr_keyboard_icons_small, 55];		// Single/Double Quotation
		default:	return [-1, -1];							// Invalid key
	}
}

/// @description Gets a given sprite for the gamepad's relative button, which can be any of the face
/// buttons, the d-pad, both sets of shoulder buttons, and the start and selects buttons. The joysticks
/// cannot be rebinded and don't need sprites for their "bindings."
/// @param keyCode
function gamepad_get_sprite(_keyCode){
	switch(_keyCode){ // Returns an array in the form of [sprite_index, image_index]
		case gp_face1:			return [spr_gamepad_icons, 0];		// A / Cross
		case gp_face2:			return [spr_gamepad_icons, 1];		// B / Circle
		case gp_face3:			return [spr_gamepad_icons, 2];		// X / Square
		case gp_face4:			return [spr_gamepad_icons, 3];		// Y / Triangle
		case gp_shoulderl:		return [spr_gamepad_icons, 10];		// LB / L1
		case gp_shoulderlb:		return [spr_gamepad_icons, 11];		// LT / L2
		case gp_shoulderr:		return [spr_gamepad_icons, 12];		// RB / R1
		case gp_shoulderrb:		return [spr_gamepad_icons, 13];		// RT / R2
		case gp_select:			return [spr_gamepad_icons, 9];		// Select / PS Button
		case gp_start:			return [spr_gamepad_icons, 8];		// Start / Options
		case gp_padu:			return [spr_gamepad_icons, 4];		// D-Pad Up
		case gp_padd:			return [spr_gamepad_icons, 6];		// D-Pad Down
		case gp_padl:			return [spr_gamepad_icons, 5];		// D-Pad Left
		case gp_padr:			return [spr_gamepad_icons, 7];		// D-Pad Right
		default:				return [-1, -1];					// Invalid gamepad button
	}
}