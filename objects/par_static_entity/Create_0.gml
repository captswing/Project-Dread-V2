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

// Variables that keep track of the entity's ambient light source. The first variable store the ID for the
// light that is attached to the current entity, and the vector below that keeps track of the position that
// the light will be in relative to the entity's current position each frame.
ambLight = noone;
lightPosition = [0, 0];

// A variable that keeps track of the audio emitter that can be attached to an entity. It can allow entities
// to play sound effects and have those sound effects placed properly in "3D" audio space; hopefully adding
// to the game's immersiveness.
audioEmitter = noone;
emitterPosition = [0, 0];

#endregion

// Adds the object to the grid for rendering using the depth sorting system.
ds_grid_resize(global.worldObjects, 2, ds_grid_height(global.worldObjects) + 1);