/// @description Gathers input for the player when they are using a keyboard for input. It allows for 
/// directional input to move around the menu, and the menu selection, exiting/return, and deleting files
/// when in the main menu's load game menu.
function menu_get_input_keyboard(){
	// The directional-movement keys for navigating through a given menu.
	keyRight =			keyboard_check(global.settings[Settings.MenuRight]);
	keyLeft =			keyboard_check(global.settings[Settings.MenuLeft]);
	keyUp =				keyboard_check(global.settings[Settings.MenuUp]);
	keyDown =			keyboard_check(global.settings[Settings.MenuDown]);
	
	// Inputs that can select highlight options, change menu states, and other things like that.
	keySelect =			keyboard_check_pressed(global.settings[Settings.Select]);
	keyReturn =			keyboard_check_pressed(global.settings[Settings.Return]);
	keyDeleteFile =		keyboard_check_pressed(global.settings[Settings.FileDelete]);
}

/// @description Gathers input for the player when they are using a gamepad for input. It allows for 
/// directional input to move around the menu, and the menu selection, exiting/return, and deleting files
/// when in the main menu's load game menu. On top of this, the left joystick can also be used for input.
function menu_get_input_gamepad(){
	// The left joystick can aldo be used for cursor navigation in the menu, so store things required for
	// joystick movement in the variables below.
	var _deadzone, _stickH, _stickV;
	_deadzone = gamepad_get_axis_deadzone(global.gamepadID);
	_stickH = gamepad_axis_value(global.gamepadID, gp_axislh);
	_stickV = gamepad_axis_value(global.gamepadID, gp_axislv);
	
	// The directional-movement keys for navigating through a given menu.
	keyRight =			gamepad_button_check(global.gamepadID, global.settings[Settings.GameRightGP]) ||	_stickH >= _deadzone;
	keyLeft =			gamepad_button_check(global.gamepadID, global.settings[Settings.GameLeftGP]) ||		_stickH <= -_deadzone;
	keyUp =				gamepad_button_check(global.gamepadID, global.settings[Settings.GameUpGP]) ||		_stickV <= -_deadzone;
	keyDown =			gamepad_button_check(global.gamepadID, global.settings[Settings.GameDownGP]) ||		_stickV >= _deadzone;
	
	// Inputs that can select highlight options, change menu states, and other things like that.
	keySelect =			gamepad_button_check(global.gamepadID, global.settings[Settings.SelectGP]);
	keyReturn =			gamepad_button_check(global.gamepadID, global.settings[Settings.ReturnGP]);
	keyDeleteFile =		gamepad_button_check(global.gamepadID, global.settings[Settings.FileDeleteGP]);
}