/// @description Editing Inherited Variables/Unique Variable Initialization

#region EDITING INHERITED VARIABLES

// Ensures that the player can walk through interactables
mask_index = spr_empty_collider;

// Initialize all variables from the static entity parent object, which include state stuff.
event_inherited();
// An outline will be drawn if the accessibility setting is toggled
drawOutline = true;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// 
canInteract = false;
interactScript = NO_SCRIPT;

// 
checkForLights = true;

#endregion