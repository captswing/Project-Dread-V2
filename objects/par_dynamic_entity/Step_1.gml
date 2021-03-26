/// @description Checks if the Entity Has Been Destroyed/Updates Light Position

if (isDestroyed){
	instance_destroy(self);
	return;
}

update_light_position(ambLight, x + lightPosition[X], y + lightPosition[Y]);