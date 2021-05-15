/// @description Insert description here
// You can write your code in this editor

lifespan -= global.deltaTime;
if (lifespan <= 0 || (endX == x && endY == y)){
	instance_destroy(self);
	return;
}

draw_set_color(c_white);
draw_set_alpha(lifespan / 500);
draw_line(x, y, endX, endY);