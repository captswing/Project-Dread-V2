/// @description Draws the Entity

// Gets the starting frame from the entity's full sprite images relative to the direction the entity
// is currently facing.
image_index = sprFrames * round(direction / sprDirections) + localFrame;

// Finally, draw the sprite to the screen using the calculated image index
draw_sprite_ext(sprite_index, image_index, x, y - zOffset, image_xscale, image_yscale, image_angle, image_blend, image_alpha);