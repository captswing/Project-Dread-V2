/// @description More General Code, But Executed At the Beginning of Frames

// The entity was flagged as "destroyed" on the previous frame; delete the object
if (isDestroyed){
	instance_destroy(self);
	return;
}

// Update positions of the optional objects that can be attached to an entity
light_update_position(ambLight, x + lightPosition[X], y + lightPosition[Y]);
emitter_update_position(audioEmitter, x + emitterPosition[X], y + emitterPosition[X]);

// Animate the entity based on their current sprite's speed in frames per second
if (animateSprite && global.gameState != GameState.Paused){
	localFrame += sprSpeed * global.deltaTime;
	if (localFrame >= sprFrames){ // Reset the image index and trigger the animation end flag
		localFrame = 0;
		animationEnd = true;
	} else{ // Resets the animation end flag
		animationEnd = false;
	}
}