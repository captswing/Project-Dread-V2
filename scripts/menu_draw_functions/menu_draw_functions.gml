/// @description A default method for drawing a menu's title. It uses the font, colors, alignment, and 
/// position that was set in the title's initialization function.
function menu_draw_title(){
	// First, the font and colors for the title needs to be set.
	currentFont = outline_set_font(titleFont, global.fontTextures[? titleFont], sPixelWidth, sPixelHeight, currentFont);
	currentOutlineColor = outline_set_color(titleColor, titleOutlineColor, sOutlineColor, currentOutlineColor);

	// Before drawing the title text, set the text alignment to reflect the title's alignment.
	draw_set_halign(titleAlign[X]);
	draw_set_valign(titleAlign[Y]);
	
	// Finally, draw the title to the screen using the correct colors.
	draw_text(titlePos[X], titlePos[Y], title);
	
	// Reset the alignment of the text when its drawn to avoid any odd issues in other drawing events.
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

/// @description A default method for drawing a menu's currently visible options. All it does is loop through
/// the grid that's size is determined by how many visible columns and rows are set in the menu. Through that
/// loop it will automatically space the options correctly based on said spacing vector, and also color the
/// options according to the highlighted option, selected options, normal, and inactive options.
function menu_draw_options(){
	// First, the font for the options needs to be set.
	currentFont = outline_set_font(optionFont, global.fontTextures[? optionFont], sPixelWidth, sPixelHeight, currentFont);
	
	// Next, set the alignment of the options to what was specified in the initialization function.
	draw_set_halign(optionAlign[X]);
	draw_set_valign(optionAlign[Y]);
	
	// After that, loop through and display the visible section of the menu to the player, which is a grid 
	// (depending on width of the menu) of a set number of rows and columns that can be viewed at once by 
	// the player.
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
	
	// Reset the alignment of the text when its drawn to avoid any odd issues in other drawing events.
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

/// @description Draws the information for the currently highlighted option. If the option that is attempting
/// to be highlighted by the user is inactive, the menu's default inactive option message will be shown instead
/// of the option's information.
function menu_draw_option_info(){
	// First, the font and colors for the option information needs to be set.
	currentFont = outline_set_font(infoFont, global.fontTextures[? infoFont], sPixelWidth, sPixelHeight, currentFont);
	currentOutlineColor = outline_set_color(infoColor, infoOutlineColor, sOutlineColor, currentOutlineColor);
	
	// Next, set the color of the text and what the visible text will actually be depending on a few factors.
	var _visibleText = visibleText;
	if (option[| curOption].isActive){ // The option is active, and the shown info can be all at once or a typewriter effect.
		currentOutlineColor = outline_set_color(infoColor, infoOutlineColor, sOutlineColor, currentOutlineColor);
		if (!scrollingInfoText) {_visibleText = option[| curOption].info;}
	} else{ // The option is inactive, so the shown info is the inactive default for the current menu.
		currentOutlineColor = outline_set_color(infoInactiveColor, infoInactiveOutlineColor, sOutlineColor, currentOutlineColor);
		if (!scrollingInfoText) {_visibleText = infoInactiveText;}
	}
	
	// Before drawing the information text, set the text alignment to reflect the information's alignment.
	draw_set_halign(infoAlign[X]);
	draw_set_valign(infoAlign[Y]);
	
	// Finally, draw the highlighted option's information to the screen using the correct colors.
	draw_text(infoPos[X], infoPos[Y], _visibleText);
	
	// Reset the alignment of the text when its drawn to avoid any odd issues in other drawing events.
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}