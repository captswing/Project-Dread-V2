/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

// Initializes the parent object's variables
event_inherited();

#endregion

#region UNIQUE VARIABLE INITIAILZATION

// This flag enables/disables the entity's ability to be drawn by the depth sorter.
drawSprite = true;

// This values calculates where the overlap of this sprite and another will occur relative to the y-positions.
zOffset = 0;

// This flag enables/disables the outline shader's effect on an object. However, if the setting is enabled
// outright; all outlined objects will be enabled as well. Likewise for when disabled.
drawOutline = false;

// A variable that stores a method's ID value. Whenever the variable is used, the relative state code will
// be executed, and for only that state's code. The lastState variable stores the previously active state.
curState = -1;
lastState = -1;

#endregion

// Adds the object to the grid for rendering using the depth sorting system.
ds_grid_resize(global.worldObjects, 2, ds_grid_height(global.worldObjects) + 1);