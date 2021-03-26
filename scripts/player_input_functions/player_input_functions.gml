/// @description Gathers player input from the keyboard. All of these controls can be remapped to whatever 
/// key the user feels like setting the keybindings to -- unlike the gamepad (more info down below). Also,
/// the player can only ever move in 8 directions with a keyboard, so the input direction and magnitude
/// reflects that.
function player_get_input_keyboard(){
	// Checking movement inputs
	keyRight =			keyboard_check(global.settings[Settings.GameRight]);
	keyLeft =			keyboard_check(global.settings[Settings.GameLeft]);
	keyUp =				keyboard_check(global.settings[Settings.GameUp]);
	keyDown =			keyboard_check(global.settings[Settings.GameDown]);
	keyRun =			keyboard_check(global.settings[Settings.Run]);

	// Checking equipment inputs
	keyReadyWeapon =	keyboard_check(global.settings[Settings.ReadyWeapon]);
	keyUseWeapon =		keyboard_check(global.settings[Settings.UseWeapon]);
	keyReload =			keyboard_check_pressed(global.settings[Settings.Reload]);
	keyAmmoSwap =		keyboard_check_pressed(global.settings[Settings.AmmoSwap]);
	keyFlashlight =		keyboard_check_pressed(global.settings[Settings.Flashlight]);

	// Checking interaction input
	keyInteract =		keyboard_check_pressed(global.settings[Settings.Interact]);
	
	// Checking menu inputs
	keyPause =			keyboard_check_pressed(global.settings[Settings.Pause]);
	keyItems =			keyboard_check_pressed(global.settings[Settings.Items]);
	keyNotes =			keyboard_check_pressed(global.settings[Settings.Notes]);
	keyMaps =			keyboard_check_pressed(global.settings[Settings.Maps]);
	
	// Calculates 8-directional movement that utilizes 2D vector movement for proper diagonal speeds
	inputDirection = point_direction(0, 0, keyRight - keyLeft, keyDown - keyUp);
	inputMagnitude = (keyRight - keyLeft != 0) || (keyDown - keyUp != 0);
}

/// @description Gathers player input from the connected gamepad. Almost every binding on the gamepad can be
/// remapped by the user to whatever input they desire. HOWEVER, the left analog stick will always control 
/// the player by default; whereas the d-pad, which by default handles movement, can be remapped by the user.
function player_get_input_gamepad(){
	var _deadzone, _stickH, _stickV;
	_deadzone = gamepad_get_axis_deadzone(global.gamepadID);
	_stickH = gamepad_axis_value(global.gamepadID, gp_axislh);
	_stickV = gamepad_axis_value(global.gamepadID, gp_axislv);
	
	// Checking movement inputs (Left Joystick always handles movement; cannot be remapped)
	keyRight =			gamepad_button_check(global.gamepadID, global.settings[Settings.GameRightGP]) || (_stickH >= _deadzone);
	keyLeft =			gamepad_button_check(global.gamepadID, global.settings[Settings.GameLeftGP]) || (_stickH <= -_deadzone);
	keyUp =				gamepad_button_check(global.gamepadID, global.settings[Settings.GameUpGP]) || (_stickV <= -_deadzone);
	keyDown =			gamepad_button_check(global.gamepadID, global.settings[Settings.GameDownGP]) || (_stickV >= _deadzone);
	keyRun =			gamepad_button_check(global.gamepadID, global.settings[Settings.RunGP]);
	
	// Checking equipment inputs
	keyReadyWeapon =	gamepad_button_check(global.gamepadID, global.settings[Settings.ReadyWeaponGP]);
	keyUseWeapon =		gamepad_button_check(global.gamepadID, global.settings[Settings.UseWeaponGP]);
	keyReload =			gamepad_button_check_pressed(global.gamepadID, global.settings[Settings.ReloadGP]);
	keyAmmoSwap =		gamepad_button_check_pressed(global.gamepadID, global.settings[Settings.AmmoSwapGP]);
	keyFlashlight =		gamepad_button_check_pressed(global.gamepadID, global.settings[Settings.FlashlightGP]);
	
	// Checking interaction input
	keyInteract =		gamepad_button_check_pressed(global.gamepadID, global.settings[Settings.InteractGP]);

	// Checking menu inputs
	keyPause =			gamepad_button_check_pressed(global.gamepadID, global.settings[Settings.PauseGP]);
	keyItems =			gamepad_button_check_pressed(global.gamepadID, global.settings[Settings.ItemsGP]);
	keyNotes =			gamepad_button_check_pressed(global.gamepadID, global.settings[Settings.NotesGP]);
	keyMaps =			gamepad_button_check_pressed(global.gamepadID, global.settings[Settings.MapsGP]);

	// Allows for 360 degrees of movement when the player moves with the joystick. Otherwise, it uses the
	// standard 8-direction movement that the keyboard movement also shares.
	if (abs(_stickH) >= _deadzone || abs(_stickV) >= _deadzone) {inputDirection = point_direction(0, 0, _stickH, _stickV);} 
	else {inputDirection = point_direction(0, 0, keyRight - keyLeft, keyDown - keyUp);}
	// Input magnitude is still calculated as normal
	inputMagnitude = (keyRight - keyLeft != 0) || (keyDown - keyUp != 0);
}