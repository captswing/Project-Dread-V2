/// @description Draws and Animates the Entity

// Gets the starting frame from the entity's full sprite images relative to the direction the entity
// is currently facing.
var _startFrame = sprFrames * round(direction / sprDirections);

// Animate the entity based on their current sprite's speed in frames per second
if (curState != NO_SCRIPT){
	localFrame += sprSpeed * global.deltaTime;
	if (localFrame >= sprFrames){ // Reset the image index and trigger the animation end flag
		localFrame = 0;
		animationEnd = true;
	} else{ // Resets the animation end flag
		animationEnd = false;
	}
}

// Finally, draw the sprite to the screen using the calculated image index
draw_sprite_ext(sprite_index, _startFrame + localFrame, x, y - zOffset, image_xscale, image_yscale, image_angle, image_blend, image_alpha);