/// @description Cleaning Up Data Structures/Removing Entity from World Objects List

// Destroying the ds_lists found within the player object
ds_list_destroy(effectTimers);
ds_list_destroy(ammoTypes);

// Removes one from the total size of the grid to save memory
ds_grid_resize(global.worldObjects, 2, ds_grid_height(global.worldObjects) - 1);