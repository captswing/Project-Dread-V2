/// @description Variables Initialization

#region EDITING INHERITED VARIABLES

image_index = 0;
image_speed = 0;
image_alpha = 0;
visible = true; // FOR TESTING

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Keyboard input state flags that track when a button is held/released/pressed. True means it's pressed or
// held down by the user, and false means the key has been released.
keyRight = false;
keyLeft = false;
keyUp = false;
keyDown = false;
keySelect = false;
keyReturn = false;
keyDeleteFile = false;

// A variable that stores a method's ID value. Whenever the variable is used, the relative state code will
// be executed, and for only that state's code. The lastState variable stores the previously active state.
curState = NO_STATE;
lastState = NO_STATE;
// Menus can use the entity's set_cur_state to change state, much like an entity object

// Variables relating to the options that the user has currently highlighted, selected, and a previous 
// auxillary option that they have selected -- one that is needed for certain tasks. (Ex. Combining Items, 
// Swapping Items Between Slots, etc.)
curOption = 0;
prevOption = 0;
selectedOption = -1;
auxSelectedOption = -1;

// Variables related to drawing the menu's visible region of options. The first vector determines the earliest
// drawn row and column -- offset from the first element of each by the values. Then, the offset determines
// how close to the border of the visible region the user needs to highlight before the visible region will
// shift over by one row/column. The dimension vector just stores the total number of rows and columns found
firstDrawn = 0;						// A 2D vector [X, Y]
numDrawn = 0;						// A 2D vector [X, Y]
scrollOffset = 0;					// A 2D vector [X, Y]
menuDimensions = 0;					// A 2D vector [X, Y]

// These variables are for automatically scrolling through the menu's options. The first is the time
// (60 == 1 second) the menu movement key has been held for, the time it needs to be held in order to 
// automatically move the cursor, the speed relative to the time needed to hold that the cursor will 
// move once autoscrolling has been activated, and finally, the flag to toggle automatic cursor scrolling 
// on and off.
holdTimer = 0;
timeToHold = 30;
autoScrollSpeed = 0.4;
isAutoScrolling = false;

// Holds the index for the shader used for outlining the text
outlineShader = shd_outline;
// Getting the uniforms for the shader; storing them in local variables
sPixelWidth = shader_get_uniform(outlineShader, "pixelWidth");
sPixelHeight = shader_get_uniform(outlineShader, "pixelHeight");
sOutlineColor = shader_get_uniform(outlineShader, "outlineColor");
sDrawOutline = shader_get_uniform(outlineShader, "drawOutline");

// Stores the currently used font for this object and the last outline color used, which prevents unnecessary
// batch breaks whenever the outline shader is being utilized.
currentFont = -1;
currentOutlineColor = -1;

// VARIABLES FOR MENU TITLE ////////////////////////////////////////////////////////

// The string for the title that will displayed at its positional coordinates; aligned to that position
// using the alignment vector. Finally, there is the font that will be used to draw said title.
title = "";
titlePos = 0;						// A 2D vector [X, Y]
titleAlign = 0;						// A 2D vector [X, Y]
titleAlpha = 0;
titleFont = -1;

// The color of the title's text and respective outline.
titleColor = c_white;
titleOutlineColor = [0.5, 0.5, 0.5];

////////////////////////////////////////////////////////////////////////////////////

// VARIABLES FOR MENU OPTIONS //////////////////////////////////////////////////////

// The ds_list that stores all the string values for the available menu options.
option = ds_list_create();			// A ds_list of indefinite length (structs containing string/position/target position/boolean)

// The position of the top element for the displayed options, and the spacing between each of the options 
// on each axis. These values don't compensate for the offset values found within an option's struct.
optionPos =	0;						// A 2D vector [X, Y]
optionSpacing = 0;					// A 2D vector [X, Y]

// The current visiblity of the options that are currently displayed, the alignment of those options relative 
// to their posiiton value, as well as the font used for the options.
optionAlign = 0;					// A 2D vector [X, Y]
optionAlpha = 0;
optionFont = -1;

// Redundant data that stores the size of the option ds_list for ease of use.
numOptions = 0;

// The colors used for options that aren't selected or being highlighted by the user current, but they are
// currently visible.
optionColor = c_white;
optionOutlineColor = [0.5, 0.5, 0.5];

// The colors used for a menu action that is disbled. A disabled option means that the player cannot currently
// interact with it and it won't be highlighted by the menu cursor.
optionInactiveColor = c_gray;
optionInactiveOutlineColor = [0.25, 0.25, 0.25];

// The colors used for a menu action that is disbled. A disabled option means that the player cannot currently
// interact with it and it won't be highlighted by the menu cursor.
optionHighlightColor = make_color_rgb(255, 233, 127);
optionHighlightOutlineColor = [0.498, 0.447, 0.247];

// The first two variables are the colors used for the option that was selected by the user. Meanwhile, the
// second pair of variables are used for an option that was selected by the user, but it now stored in an
// auxillary buffer for use once another option is selected by the user. (Ex. Combining Items, Swapping Items)
optionSelectedColor = make_color_rgb(182, 255, 0);
optionSelectedOutlineColor = [0.358, 0.5, 0];
optionAuxSelectedColor = make_color_rgb(255, 0, 0);
optionAuxSelectedOutlineColor = [0.5, 0, 0];

////////////////////////////////////////////////////////////////////////////////////

// VARIABLES FOR MENU OPTIONS INFO /////////////////////////////////////////////////

// The vector to store the position of the information on the screen, and another vector for the alignment
// of that text relative to the position of the information. Next, a variable that stores how long a single 
// line in the info text can be before a new line is created. Finally, the info's alpha and the used font is 
// found below those variables.
infoPos = 0;						// A 2D vector [X, Y]
infoAlign = 0;						// A 2D vector [X, Y]
infoMaxWidth = 0;
infoAlpha = 0;
infoFont = -1;

// The color of both the inside of the iunformation text and its accompanying outline for when the option is
// active; otherwise, another set of variables will be used for the color.
infoColor = c_white;
infoOutlineColor = [0.5, 0.5, 0.5];

// The color for the information text when the option that's tied to the info text is current set to inactive.
// When this occurs -- not only will the color change, but the typrwriter scrolling effect will be disabled.
infoInactiveColor = c_gray;
infoInactiveOutlineColor = [0.25, 0.25, 0.25];

// The default text that appears in the information section of a given menu when an inactive option is being
// highlighted by the user. It can be altered on a per-menu basis or just kept as the default that was set here.
// Below that is the length of the inactive text so the scrolling effect can work with the inactive text, too.
infoInactiveText = "---";
infoInactiveTextLength = string_length(infoInactiveText);

// A flag that enables/disables the information text to smoothly scroll onto the screen for displaying. The 
// next three variables below are the exact same in function as the "obj_textbox" variables, which share the
// same names as those variables as well. The currently visible text is stored, the next character is what
// will be added to said visible text next, and the final character tells the scroll effect when it has 
// completed typing out the string.
scrollingInfoText = false;
visibleText = "";
nextCharacter = 0;
finalCharacter = 0;

////////////////////////////////////////////////////////////////////////////////////

#endregion

menu_general_initialize(6, 3, 7, 1, 2, 25, 0.4);
menu_options_initialize(5, 55, fa_left, fa_top, 40, 12, font_gui_small);
menu_option_info_initialize(5, 155, fa_left, fa_top, 120, true, font_gui_small);

for (var i = 0; i < 45; i++) {menu_option_add(-1, "test" + string(i), "test_info" + string(i), true);}
menu_option_set_active(15, false);

menu_option_set_cur_option(curOption);
menu_option_info_set_inactive_text("This is a test for the menu's inactive option text.");

set_game_state(GameState.InMenu, true);