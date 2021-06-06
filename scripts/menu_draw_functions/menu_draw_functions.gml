/// @description 
function menu_draw_title(){
	
}

/// @description 
function menu_draw_options(){
	// First, the font for the options needs to be set.
	currentFont = outline_set_font(optionFont, global.fontTextures[? optionFont], sPixelWidth, sPixelHeight, currentFont);
	
	// After the font has been correctly set by the function above, loop through and display the visible
	// section of the menu to the player, which is a grid (depending on width of the menu) of a set number
	// of rows and columns that can be viewed at once by the player.
	var _indexX, _indexY, _optionPos, _optionSpacing, _curOption;
	_indexX = 0;
	_indexY = 0;
	_optionPos = [optionPos[X], optionPos[Y]];
	_optionSpacing = [optionSpacing[X], optionSpacing[Y]];
	for (var yy = firstDrawn[Y]; yy < firstDrawn[Y] + numDrawn[Y]; yy++){
		for (var xx = firstDrawn[X]; xx < firstDrawn[X] + numDrawn[X]; xx++){
			_curOption = (menuDimensions[X] * yy) + xx; // Gets the option's true index within the menu based on its width
		
			// Early exit if the _curOption variable is greater than the menu's size
			if (_curOption >= numOptions) {break;}
		
			// This bunch of if statements alters the color of the text relative to the current optionn that is
			// being drawn to the screen; whether its selected, an auxillary selection, highlighted, or just
			// visible to the player currently.
			if (!option[| _curOption].isActive){ // The option is using the menu's inactive colors
				currentOutlineColor = outline_set_color(optionInactiveColor, optionInactiveOutlineColor, sOutlineColor, currentOutlineColor);
			} else if (_curOption == selectedOption){ // The option is using the default selection colors for the menu
				currentOutlineColor = outline_set_color(optionSelectedColor, optionSelectedOutlineColor, sOutlineColor, currentOutlineColor);
			} else if (_curOption == auxSelectedOption){ // The option is using the auxillary selection colors for the menu
				currentOutlineColor = outline_set_color(optionAuxSelectedColor, optionAuxSelectedOutlineColor, sOutlineColor, currentOutlineColor);
			} else if (_curOption == curOption){ // The option is using the menu's highlighted option colors
				currentOutlineColor = outline_set_color(optionHighlightColor, optionHighlightOutlineColor, sOutlineColor, currentOutlineColor);
			} else{ // The option is using the standard colors for the menu
				currentOutlineColor = outline_set_color(optionColor, optionOutlineColor, sOutlineColor, currentOutlineColor);
			}
			// Draw the option's name text relative to its current position and offsets
			with(option[| _curOption]) {draw_text(_optionPos[X] + (_optionSpacing[X] * _indexX) + curOffsetX, _optionPos[Y] + (_optionSpacing[Y] * _indexY) + curOffsetY, option);}
	
			// Next, increment the X index variable
			_indexX++;
		}
		// Early exit if the _curOption variable is greater than the menu's size
		if (_curOption >= numOptions) {break;}
	
		// Finally, increment the Y index and reset the X index for the new row
		_indexY++;
		_indexX = 0;
	}
}

/// @description 
function menu_draw_option_info(){
	// First, the font for the option information needs to be set.
	currentFont = outline_set_font(infoFont, global.fontTextures[? infoFont], sPixelWidth, sPixelHeight, currentFont);
	
	// Next, set the color of the text and what the visible text will actually be depending on a few factors.
	var _visibleText = visibleText;
	if (option[| curOption].isActive){ // The option is active, and the shown info can be all at once or a typewriter effect.
		currentOutlineColor = outline_set_color(infoColor, infoOutlineColor, sOutlineColor, currentOutlineColor);
		if (!scrollingInfoText) {_visibleText = option[| curOption].info;}
	} else{ // The option is inactive, so the shown info is the inactive default for the current menu.
		currentOutlineColor = outline_set_color(infoInactiveColor, infoInactiveOutlineColor, sOutlineColor, currentOutlineColor);
		if (!scrollingInfoText) {_visibleText = infoInactiveText;}
	}
	
	// Finally, draw the highlighted option's information to the screen using the correct colors.
	draw_text(infoPos[X], infoPos[Y], _visibleText);
}