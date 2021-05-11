// Set the position and room the player will be warped to
targetX = 120;
targetY = 300;
targetRoom = rm_test0;

// Set the sound effects to be played when the door is locked, opened, or closed
doorLockedSound = snd_door_locked0;

// Finally, add the required keys for the door to be unlocked to the list of needed keys and the 
// event index for the locked door itself, which toggles true once it's been unlocked.
ds_list_add(requiredKeys, HANDGUN_AMMO);
ds_list_add(requiredKeys, HANDGUN_AMMO);
eventFlagIndex = 1;