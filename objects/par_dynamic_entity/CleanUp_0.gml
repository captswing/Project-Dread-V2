/// @description Clean Up the Entity

// Delete the ambient light and audio emitter source if they exist
with(ambLight)		{instance_destroy(self);}
with(audioEmitter)	{instance_destroy(self);}

// Removes one from the total size of the grid to save memory
ds_grid_resize(global.worldObjects, 2, ds_grid_height(global.worldObjects) - 1);