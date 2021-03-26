/// @description Weather Effects/Debug Stuff

// Display the current weather effect if one is active
if (weatherEffect != noone){
	var _alpha = weatherAlpha;
	with(weatherEffect) {Draw(_alpha);}
}

if (!showDebugInfo){
	return;
}

with(par_dynamic_entity){
	switch(object_index){
		case obj_player:
			draw_rect_outline(bbox_left, bbox_top, 1 + (bbox_right - bbox_left), 1 + (bbox_bottom - bbox_top), c_white, c_gray, 0.5, 1);
			break;
	}
}