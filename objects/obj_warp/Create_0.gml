/// @description Editing Inherited Variable/Unique Variable Initialization

#region EDITING INHERITED VARIABLES

// Initialize all variables from the static entity parent object, which include state stuff.
event_inherited();
// Adjust some of the interaction variables to fit the warp better
interactRadius = 10;
interactCenter = [x + 8, y + 4];
// Set the interation script to be the script involving room warping/key checking.
interactScript = interact_room_warp;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// 
requiredKeys = ds_list_create();

// 
targetX = 0;
targetY = 0;
targetRoom = -1;

// 
doorLockedSound = -1;
doorOpenSound = -1;
doorCloseSound = -1;

#endregion