/// @description Updating Textbox Information/Handling Input

#region CHECKING INPUT FROM PLAYER

// Gets input from the currently active control method (Keyboard/Gamepads supported)
if (!global.gamepadActive) {keyAdvance = keyboard_check_pressed(global.settings[Settings.Interact]);}
else {keyAdvance = gamepad_button_check_pressed(global.gamepadID, global.settings[Settings.Interact]);}

#endregion

#region OPENING AND CLOSING ANIMATION

// Moves the textbox towards its target; which is faster the further away it is from the target
y += ((yTarget - y) / 5) * global.deltaTime;
// Handling the visiblity of the textbox
if (!isClosing){ // Fades the textbox into visiblity
	alpha += 0.1 * global.deltaTime;
	if (alpha > 1) {alpha = 1;}
	else {keyAdvance = false;} // Don't allow input until the textbox is fully visible
} else{ // Fades the textbox out
	alpha -= 0.1 * global.deltaTime;
	if (alpha < 0){ // Switching from the currently visible textbox to the next one
		open_next_textbox();
		// Finally, reset the flag for the animation and the position of the textbox
		y = WINDOW_HEIGHT + 10;
		isClosing = false;
	}
	// Don't allow input when the textbox is "closing"
	return;
}

#endregion

#region HANDLING INPUT/UPDATING TEXTBOX

// Advancing the text/skipping the typewriter effect
if (keyAdvance){
	if (nextCharacter > 4 && nextCharacter < finalCharacter){ // Display the entire string at once, skipping the animation
		nextCharacter = finalCharacter;
	} else{ // Starts the "closing" transition to move onto the next textbox if the actor is different
		if (ds_list_size(textboxData) > 1 && textboxData[| 0][1] == textboxData[| 1][1]){
			open_next_textbox();
			return; // Exit out of the event early
		}
		// The actor isn't the same; start the transition to the next textbox
		isClosing = true;
	}
}

// Makes the "text fully visible" indicator move up and down
indicatorOffset += indicatorSpeed * global.deltaTime;
if (indicatorOffset >= 2) {indicatorOffset = 0;}

// Updating the currently visible portion of the text based on current set text speed
if (nextCharacter <= finalCharacter){
	nextCharacter += global.settings[Settings.TextSpeed] * global.deltaTime;
	visibleText = string_copy(textboxData[| 0][0], 1, nextCharacter);
	// Play the text crawl's sound effect at a set speed interval
	textboxSoundTimer -= global.deltaTime;
	if (textboxSoundTimer < 0){
		textboxSoundID = play_sound_effect(snd_ui_textbox_scroll, 0.15, true);
		textboxSoundTimer += textboxSoundSpeed;
	}
}

#endregion