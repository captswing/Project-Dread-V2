/// @description Initializes all of the basic elements that are required for the menu to function properly.
/// Otherwise, input will not be allowed and the menu object itself will more than likely crash the game.
function menu_general_initialize(_menuWidth, _numVisibleColumns, _numVisibleRows, _scrollOffsetX, _scrollOffsetY, _timeToHold, _autoScrollSpeed){
	// The width of the menu allows for both 2-dimensional and 1-dimensional menus; depending on the total
	// width that was provided. Otherwise, input will not be allowed and it'll more than likely crash the game.
	menuDimensions = [max(1, _menuWidth), 0];
	
	// The number of rows/columns visible to the user at once and the offset needed to scroll the visible
	// portion of the menu. The values for both must be one or above and zero or above, respectively.
	numDrawn = [clamp(_numVisibleColumns, 1, menuDimensions[X]), max(1, _numVisibleRows)];
	scrollOffset = [max(0, _scrollOffsetX), max(0, _scrollOffsetY)];
	
	// The speed of the cursor whenever it is automatically scrolling through the options. The values for both 
	// must be greater than 5 (60 = 1 second of real-time) and 0.01 (smaller values = faster), respectively.
	timeToHold = max(5, _timeToHold);
	autoScrollSpeed = max(0.01, _autoScrollSpeed);
	
	// The first drawn vector will always be set to [0, 0] upon initialization
	firstDrawn = [0, 0];
}

/// @description Initializes the title contents, as well as the position, font, and alignment of it relative
/// to the position value that was set in the function's argument space as well.
/// @param title
/// @param xPos
/// @param yPos
/// @param hAlign
/// @param vAlign
/// @param font
function menu_title_initialize(_title, _xPos, _yPos, _hAlign, _vAlign, _font){
	title = _title;
	titlePos = [_xPos, _yPos];
	titleAlign = [_hAlign, _vAlign];
	titleFont = _font;
}

/// @description Initializes the position, font, spacing between, and alignment of the option text. The
/// alignment values alter how the text is displayed relative to its given position.
/// @param xPos
/// @param yPos
/// @param hAlign
/// @param vAlign
/// @param xSpacing
/// @param ySpacing
/// @param font
function menu_options_initialize(_xPos, _yPos, _hAlign, _vAlign, _xSpacing, _ySpacing, _font){
	optionPos = [_xPos, _yPos];
	optionAlign = [_hAlign, _vAlign];
	optionSpacing = [_xSpacing, _ySpacing];
	optionFont = _font;
}

/// @description Initializes the position, alignment, and the font for the option information text. The
/// alignment values alter how the text is displayed relative to its given position. Also, it's important
/// to note that all menu options should be initialized before calling this function, since it piggybacks
/// of the options themselves which store the info text. It's only required to keep that in mind if the info
/// text is set to have a typewriter effect.
/// @param xPos
/// @param yPos
/// @param hAlign
/// @param vAlign
/// @param infoMaxWidth
/// @param scrollText
/// @param font
function menu_option_info_initialize(_xPos, _yPos, _hAlign, _vAlign, _infoMaxWidth, _scrollText, _font){
	infoPos = [_xPos, _yPos];
	infoAlign = [_hAlign, _vAlign];
	infoMaxWidth = _infoMaxWidth;
	scrollingInfoText = bool(_scrollText);
	infoFont = _font;
}