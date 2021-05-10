/// @description Draws the Entity

// Gets the starting frame from the entity's full sprite images relative to the direction the entity
// is currently facing.
var _startFrame = sprFrames * round(direction / sprDirections);

// Finally, draw the sprite to the screen using the calculated image index
draw_sprite_ext(sprite_index, _startFrame + localFrame, x, y - zOffset, image_xscale, image_yscale, image_angle, image_blend, image_alpha);