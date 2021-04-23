/// @description Cleaning Up Allocated Memory and Other Data

// Don't clean up uninitialized data if the player object was a duplicate of the existing singleton
if (global.singletonID[? PLAYER] != id) {return;}

// Remove this id value from the player singleton; allowing another instance of obj_player to take its place
remove_singleton_object();

// Destroying the ds_lists, and ds_maps found within the player object
ds_list_destroy(effectTimers);
ds_list_destroy(ammoTypes);
ds_map_destroy(lastAmmoType);

// Removes the ambient light source and deletes the entity from the depth sorting list
event_inherited();