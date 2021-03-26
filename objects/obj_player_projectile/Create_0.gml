/// @description Unique Variable Initialization

#region EDITING INHERITED VARIABLES

// Initialize variables found in the parent's create event
event_inherited();
// Sets the z-offset of the projectile to 8 pixels above its true position
zOffset = 12;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// The two variables that are shared between the player and this projectile. It combines the base damage,
// range values and both their modifier values into a pair of variables that can be referenced from this
// object for ease during collision.
damage = 0;
range = 0;

// 
startX = 0;
startY = 0;

#endregion