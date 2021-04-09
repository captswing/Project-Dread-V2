/// @description Clean Up the Entity

// Removes one from the total size of the grid to save memory
ds_grid_resize(global.worldObjects, 2, ds_grid_height(global.worldObjects) - 1);