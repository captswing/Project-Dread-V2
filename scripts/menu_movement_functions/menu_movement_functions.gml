/// @description Provides input functionality for the menu's cursor. Enables selecting of menu options,
/// moving between them, backing out of selecting an item, or exiting the menu.
function menu_cursor_movement(){
	// Set the previous option to whatever the curOption value is before any input is considered
	prevOption = curOption;
	
	// Pressing the select key will ignore any directional menu input and instantly exit; much like the
	// return key check below. The differences being that the currently highlighted option will be selected,
	// which prevents directional input for the current menu.
	if (keySelect && selectedOption == -1){
		if (option[| curOption].isActive){ // Play a sound effect and select the current option
			// TODO -- Play menu select sound here
			selectedOption = curOption;
		} else{ // Play an error sound to let the player know they can't select this option
			// TODO -- Play menu selection error sound here
		}
		return;
	}
	
	// An if statement that prevents any movement in the menu from occuring, which is caused by the number
	// of options in the menu being 1 or less OR if the player has selected an option in the menu. If these
	// conditions are reversed after being set the menu's movement will be enabled again.
	if (numOptions <= 1 || selectedOption != -1){
		holdTimer = 0; // Prevents any delay from moving through the menu if a value greater than 0 is currently stored in the variable.
		return;
	}
	
	// Pressing the return key will ignore any directional menu input and play the sound effect for 
	// closing/exiting a section of the menu or the menu itself. 
	if (keyReturn){
		// TODO -- Play return sound here
		auxSelectedOption = curOption; // FOR TESTING
		return;
	}
	
	// Store checks for horizontal and vertical movement in seperate variables; to simplify the if statement
	// below and to allow for easy reference of the result in other parts of the code.
	var _movementHorizontal, _movementVertical;
	_movementHorizontal =	((keyRight && !keyLeft) || (keyLeft && !keyRight)) && menuDimensions[X] > 1;
	_movementVertical =		((keyDown && !keyUp) || (keyUp && !keyDown)) && menuDimensions[Y] > 1;
	
	// If either of the above statements returns true, update the menu cursor's position
	if (_movementHorizontal || _movementVertical){
		// Decrement the auto-scrolling timer by a set number per second (Around a value of 60 per second)
		holdTimer -= global.deltaTime;

		// Update the currently highlighted option (Also known as the curOption variable)
		if (holdTimer <= 0){
			if (!isAutoScrolling){ // Enable the menu's auto-scrolling
				isAutoScrolling = true;
				holdTimer = timeToHold;
			} else{ // Reduce time  needed to move cursor for auto-scrolling
				holdTimer = timeToHold * autoScrollSpeed;
			}
			
			// Moving up/down to different rows in the menu
			if (_movementVertical){
				curOption += (keyDown - keyUp) * menuDimensions[X];
				
				var _curRow = floor(curOption / menuDimensions[X]);
				if (keyUp && firstDrawn[Y] > 0 && _curRow < firstDrawn[Y] + scrollOffset[Y]){
					firstDrawn[Y]--; // Shift the visible region upward by one row
				} else if (keyDown && firstDrawn[Y] < menuDimensions[Y] - numDrawn[Y] && _curRow >= firstDrawn[Y] + (numDrawn[Y] - scrollOffset[Y])){
					firstDrawn[Y]++; // Shift the visible region downward by one row
				}
				
				if (curOption >= numOptions){ // Wrap the currently highlighted option to the lowest value for that column
					curOption = curOption % menuDimensions[X];
					// Reset the menu's visible vertical region back to a range of 0 to the number of rows to draw
					firstDrawn[Y] = 0;
				} else if (curOption < 0){ // Wrap the currently highlighted option to the hightest value of that column
					curOption = ((menuDimensions[Y] - 1) * menuDimensions[X]) + prevOption;
					if (curOption >= numOptions) {curOption -= menuDimensions[X];}
					// Offset the visible vertical region to its highest possible value, but no value below 0
					firstDrawn[Y] = max(0, menuDimensions[Y] - numDrawn[Y]);
				}
			}
			
			// Moving left/right through the menu if there is more than one option per row
			if (_movementHorizontal){
				curOption += (keyRight - keyLeft);
				
				var _curColumn = curOption % menuDimensions[X];
				if (keyLeft && firstDrawn[X] > 0 && _curColumn < firstDrawn[X] + scrollOffset[X]){
					firstDrawn[X]--; // Shift the visible region to the left
				} else if (keyRight && firstDrawn[X] < menuDimensions[X] - numDrawn[X] && _curColumn >= firstDrawn[X] + (numDrawn[X] - scrollOffset[X])){
					firstDrawn[X]++; // Shift the visible region to the right
				}
				
				// Check if the cursor needs to wrap around to the other side based on the left or right keyboard input
				if (keyRight && (curOption % menuDimensions[X] == 0 || curOption == numOptions)){
					if (curOption >= numOptions - 1 && curOption % menuDimensions[X] != 0){ // Wrap around to the left side relative to the amount of options on that final row
						curOption = (numOptions - 1) - ((numOptions - 1) % menuDimensions[X]);
					} else{ // Isn't the last row's unique case; wrap to the left side as normal
						curOption -= menuDimensions[X];
					}
					// Reset the menu's visible region back to a range of 0 to the number of columns to drawn
					firstDrawn[X] = 0;
				} else if (keyLeft && (curOption % menuDimensions[X] == menuDimensions[X] - 1 || curOption == -1)){
					curOption += menuDimensions[X];
					firstDrawn[X] = menuDimensions[X] - numDrawn[X];
					if (curOption >= numOptions - 1){ // Lock onto the option farthest to the right in the last row
						curOption = numOptions - 1;
						// Fix the offset for the first column of options
						firstDrawn[X] = clamp((curOption % menuDimensions[X]) - scrollOffset[X], 0, menuDimensions[X]);
					}
				}
			}
			
			// Finally, reset the info text's variables if scrolling text has been enabled
			if (scrollingInfoText){
				visibleText = "";
				nextCharacter = 0;
				// If the option is active it will use its own info text, otherwise the default inactive text is used.
				finalCharacter = option[| curOption].isActive ? string_length(option[| curOption].info) : infoInactiveTextLength;
			}
		}
	} else{ // No directional keys are being held; reset auto-scroll stat and its associated timer
		isAutoScrolling = false;
		holdTimer = 0;
	}
}