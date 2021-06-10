/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

// Call the parent menu's create event to initialize all the default variables
event_inherited();
// Initialize the general menu variables, but the menu's width, height, and scroll offsets will actually be
// determined by the curretn section of the menu that is opened currently.
menu_general_initialize(true, 1, 1, 1, 0, 0, 30, 0.4);
// Initialize the menu's title, options, and option information variables, but don't actually place any data
// inside of the initialized data structures; as that is handled by the function to open a specific section
// of the player's inventory. (Can be either map, items, or notes)
menu_title_initialize("", 0, 0, fa_left, fa_top, font_gui_medium);
menu_options_initialize(0, 0, fa_left, fa_top, 0, 0, font_gui_medium);
menu_option_info_initialize(5, 145, fa_left, fa_top, 240, true, font_gui_small); // Option info only used by item section

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// 
lastSectionOption = array_create(MAP_SECTION + 1, 0);
curSection = 0;

// 
drawFunction = NO_SCRIPT;

// 
optionRectHighlightOutlineColor = make_color_rgb(127, 114, 63);
optionRectSelectedOutlineColor = make_color_rgb(91, 127, 0);
optionRectAuxSelectedOutlineColor = make_color_rgb(127, 0, 0);

#endregion