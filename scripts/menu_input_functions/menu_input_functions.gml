/// @description 
function menu_get_input_keyboard(){
	// 
	keyRight =			keyboard_check(global.settings[Settings.MenuRight]);
	keyLeft =			keyboard_check(global.settings[Settings.MenuLeft]);
	keyUp =				keyboard_check(global.settings[Settings.MenuUp]);
	keyDown =			keyboard_check(global.settings[Settings.MenuDown]);
	
	// 
	keySelect =			keyboard_check_pressed(global.settings[Settings.Select]);
	keyReturn =			keyboard_check_pressed(global.settings[Settings.Return]);
	keyDeleteFile =		keyboard_check_pressed(global.settings[Settings.FileDelete]);
}

/// @description 
function menu_get_input_gamepad(){
	var _deadzone, _stickH, _stickV;
	_deadzone = gamepad_get_axis_deadzone(global.gamepadID);
	_stickH = gamepad_axis_value(global.gamepadID, gp_axislh);
	_stickV = gamepad_axis_value(global.gamepadID, gp_axislv);
	
	// 
	keyRight =			gamepad_button_check(global.gamepadID, global.settings[Settings.GameRightGP]) ||	_stickH >= _deadzone;
	keyLeft =			gamepad_button_check(global.gamepadID, global.settings[Settings.GameLeftGP]) ||		_stickH <= -_deadzone;
	keyUp =				gamepad_button_check(global.gamepadID, global.settings[Settings.GameUpGP]) ||		_stickV <= -_deadzone;
	keyDown =			gamepad_button_check(global.gamepadID, global.settings[Settings.GameDownGP]) ||		_stickV >= _deadzone;
	
	// 
	keySelect =			gamepad_button_check(global.gamepadID, global.settings[Settings.SelectGP]);
	keyReturn =			gamepad_button_check(global.gamepadID, global.settings[Settings.ReturnGP]);
	keyDeleteFile =		gamepad_button_check(global.gamepadID, global.settings[Settings.FileDeleteGP]);
}