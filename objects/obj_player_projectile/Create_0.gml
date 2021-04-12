/// @description Unique Variable Initialization

#region EDITING INHERITED VARIABLES

// Initialize variables found in the parent's create event
event_inherited();
// Sets the z-offset of the projectile to 12 pixels above its true position
zOffset = 12;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// The three variables that are shared between the player and this projectile. The first variable stores the
// name of the weapon that fired this projectile. Meanwhile, the second and third contain the combined damage
// and damage modifier, as well as the range and range modifier, respectively.
weaponName = 0;
damage = 0;
range = 0;

// Stores the beginning positions for the bullet relative to their current position in the frame. If the
// projectile's current position and this starting point exceeds the range in length, the projectile will be
// deleted and do what it usually does upon destruction. This could be nothing or specific effects like explosions.
startX = 0;
startY = 0;

#endregion