/// @description Checks if the Entity Has Been Destroyed/Updates Light and Emitter Positions

if (isDestroyed){
	instance_destroy(self);
	return;
}

light_update_position(ambLight, x + lightPosition[X], y + lightPosition[Y]);
emitter_update_position(audioEmitter, x + emitterPosition[X], y + emitterPosition[X]);