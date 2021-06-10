/// @description Getting Key Input, Running Menu State Code and Other General Code

// If the menu doesn't current have a state set or the game state is set to paused, don't execute event code
if (curState == NO_STATE || global.gameState == GameState.Paused) {return;}

// Gets input from the currently active control method (Keyboard/Gamepads supported)
if (!global.gamepadActive) {menu_get_input_keyboard();}
else {menu_get_input_gamepad();}

// Call the code contained within the menu's currently set state.
script_execute(curState);

// The code that handles the auto-scrolling effect for the menu's currently visible information text. It simply
// advances the nextCharacter variable by the accessibility setting for text speed, and then copies that amount
// of text to the currently visible text string. The text it copies from determines on if the option is active
// or not; using the option's info text or the inactive default for the menu, respectively.
if (curOption < numOptions && scrollingInfoText && nextCharacter <= finalCharacter){
	nextCharacter += global.settings[Settings.TextSpeed] * global.deltaTime;
	if (option[| curOption].isActive) {visibleText = string_copy(option[| curOption].info, 1, nextCharacter);}
	else {visibleText = string_copy(infoInactiveText, 1, nextCharacter);}
}