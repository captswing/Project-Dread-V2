/// @description Getting Key Input, Running Menu State Code and Other General Code

// 
//if (curState == NO_STATE || global.gameState == GameState.Paused) {return;}

// Gets input from the currently active control method (Keyboard/Gamepads supported)
if (!global.gamepadActive) {menu_get_input_keyboard();}
else {menu_get_input_gamepad();}

// TODO -- Replace the line below this one with a script_execute for the menu's current state.
menu_cursor_movement();

// The code that handles the auto-scrolling effect for the menu's currently visible information text. It simply
// advances the nextCharacter variable by the accessibility setting for text speed, and then copies that amount
// of text to the currently visible text string. The text it copies from determines on if the option is active
// or not; using the option's info text or the inactive default for the menu, respectively.
if (scrollingInfoText && nextCharacter <= finalCharacter){
	nextCharacter += global.settings[Settings.TextSpeed] * global.deltaTime;
	if (option[| curOption].isActive) {visibleText = string_copy(option[| curOption].info, 1, nextCharacter);}
	else {visibleText = string_copy(infoInactiveText, 1, nextCharacter);}
}