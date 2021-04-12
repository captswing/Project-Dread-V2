/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

// Inherit all the variables from the parent object
event_inherited();

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Stores the damage that the enemy deals to the player without the player's damage resistance or the global
// enemy damage modifier applied to it. In short, it's the base damage the enemy deals out.
damage = 0;

// The variables that handle the enemy's stun lock. The first variable is the damage that the projectile will
// need to to cause a stun lock to always occur. If that isn't the case, however, the stun lock will occur at
// a percent chance; which is stored in the second variable. Finally, the last variable is the time that the
// enemy will remain stunlocked for. (60 = 1 second)
stunLockThreshold = 0;
stunLockChance = 0;
stunLockTime = 0;

#endregion