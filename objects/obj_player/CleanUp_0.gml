/// @description Cleaning Up Allocated Memory and Other Data

// Don't clean up uninitialized data if the player object was a duplicate of the existing singleton
if (global.singletonID[? PLAYER] != id) {return;}

// Remove this id value from the player singleton; allowing another instance of obj_player to take its place
remove_singleton_object();

// Destroying the ds_lists found within the player object
ds_list_destroy(effectTimers);
ds_list_destroy(ammoTypes);

// Removes one from the total size of the grid to save memory
ds_grid_resize(global.worldObjects, 2, ds_grid_height(global.worldObjects) - 1);