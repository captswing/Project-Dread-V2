/// @description Drawing the Line

lifespan -= global.deltaTime;
if (lifespan <= 0 || (endX == x && endY == y)){
	instance_destroy(self);
	return;
}

draw_set_color(c_white);
draw_set_alpha(lifespan / initialLifespan);
draw_line(x, y, endX, endY);